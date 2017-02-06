// Prevent Visual Studio Intellisense from defining _WIN32 and _MSC_VER when we use 
// Visual Studio to edit Linux or Borland C++ code.
#ifdef __linux__
#	undef _WIN32
#endif // __linux__
#if defined(__GNUC__) || defined(__BORLANDC__)
#	undef _MSC_VER
#endif // defined(__GNUC__) || defined(__BORLANDC__)

#include "Config.h"
#include "ublox.h"

THREAD_PROC_RETURN_VALUE ubloxThread(void* pParam)
{
	UBLOX ublox;
	UBXDATA ubxdata;
	double dval = 0;
	BOOL bConnected = FALSE;
	int deviceid = (intptr_t)pParam;
	char szCfgFilePath[256];
	int i = 0;
	char szSaveFilePath[256];
	char szTemp[256];

	//UNREFERENCED_PARAMETER(pParam);

/*

	char* buf = "$GPRMC,163634.000,A,4825.0961,N,00428.3419,W,0.00,309.63,150512,,,A*70\r\n";
	int buflen = strlen(buf)+1;
	int sentencelen = 0, nbBytesToRequest = 0, nbBytesToDiscard = 0;
	char talkerid[3];
	char mnemonic[4];

	AnalyzeSentenceNMEA(buf, buflen, talkerid, mnemonic, &sentencelen, 
								  &nbBytesToRequest, &nbBytesToDiscard);



*/

	sprintf(szCfgFilePath, "ublox%d.txt", deviceid);

	memset(&ublox, 0, sizeof(UBLOX));

	bGPSOKublox[deviceid] = FALSE;

	for (;;)
	{
		//mSleep(100);

		if (bPauseublox[deviceid])
		{
			if (bConnected)
			{
				printf("ublox paused.\n");
				bGPSOKublox[deviceid] = FALSE;
				bConnected = FALSE;
				Disconnectublox(&ublox);
			}
			if (bExit) break;
			mSleep(100);
			continue;
		}

		if (bRestartublox[deviceid])
		{
			if (bConnected)
			{
				printf("Restarting a ublox.\n");
				bGPSOKublox[deviceid] = FALSE;
				bConnected = FALSE;
				Disconnectublox(&ublox);
			}
			bRestartublox[deviceid] = FALSE;
		}

		if (!bConnected)
		{
			if (Connectublox(&ublox, szCfgFilePath) == EXIT_SUCCESS) 
			{
				bConnected = TRUE; 

				if (ublox.pfSaveFile != NULL)
				{
					fclose(ublox.pfSaveFile); 
					ublox.pfSaveFile = NULL;
				}
				if ((ublox.bSaveRawData)&&(ublox.pfSaveFile == NULL)) 
				{
					if (strlen(ublox.szCfgFilePath) > 0)
					{
						sprintf(szTemp, "%.127s", ublox.szCfgFilePath);
					}
					else
					{
						sprintf(szTemp, "ublox");
					}
					// Remove the extension.
					for (i = strlen(szTemp)-1; i >= 0; i--) { if (szTemp[i] == '.') break; }
					if ((i > 0)&&(i < (int)strlen(szTemp))) memset(szTemp+i, 0, strlen(szTemp)-i);
					//if (strlen(szTemp) > 4) memset(szTemp+strlen(szTemp)-4, 0, 4);
					EnterCriticalSection(&strtimeCS);
					sprintf(szSaveFilePath, LOG_FOLDER"%.127s_%.64s.txt", szTemp, strtime_fns());
					LeaveCriticalSection(&strtimeCS);
					ublox.pfSaveFile = fopen(szSaveFilePath, "wb");
					if (ublox.pfSaveFile == NULL) 
					{
						printf("Unable to create ublox data file.\n");
						break;
					}
				}
			}
			else 
			{
				bGPSOKublox[deviceid] = FALSE;
				bConnected = FALSE;
				mSleep(1000);
			}
		}
		else
		{
			if (GetDataublox(&ublox, &ubxdata) == EXIT_SUCCESS)
			{
				EnterCriticalSection(&StateVariablesCS);

				// lat/lon might be temporarily bad we this... 
				if (ubxdata.nav_status_pl.gpsFix >= 0x02)
				{
					//printf("%f;%f\n", ubxdata.Latitude, ubxdata.Longitude);
					latitude = ubxdata.Latitude;
					longitude = ubxdata.Longitude;
					GPS2EnvCoordSystem(lat_env, long_env, alt_env, angle_env, latitude, longitude, 0, &x_mes, &y_mes, &dval);
					bGPSOKublox[deviceid] = TRUE;
				}
				else
				{
					bGPSOKublox[deviceid] = FALSE;
				}

/*
				//printf("GPS_quality_indicator : %d, status : %c\n", ubxdata.GPS_quality_indicator, ubxdata.status);

				if ((ubxdata.GPS_quality_indicator > 0)||(ubxdata.status == 'A'))
				{
					//printf("%f;%f\n", ubxdata.Latitude, ubxdata.Longitude);
					latitude = ubxdata.Latitude;
					longitude = ubxdata.Longitude;
					GPS2EnvCoordSystem(lat_env, long_env, alt_env, angle_env, latitude, longitude, 0, &x_mes, &y_mes, &dval);
					bGPSOKublox[deviceid] = TRUE;
				}
				else
				{
					bGPSOKublox[deviceid] = FALSE;
				}

				// Should check better if valid...
				if ((ublox.bEnableGPRMC&&(ubxdata.status == 'A'))||ublox.bEnableGPVTG)
				{
					sog = ubxdata.SOG;
					cog = fmod_2PI(M_PI/2.0-ubxdata.COG-angle_env);
				}

				if (ublox.bEnableHCHDG)
				{
					if (robid == SAILBOAT_ROBID) theta_mes = fmod_2PI(M_PI/2.0-ubxdata.Heading-angle_env);
				}

				if (ublox.bEnableIIMWV||ublox.bEnableWIMWV)
				{
					// Apparent wind (in robot coordinate system).
					psiawind = fmod_2PI(-ubxdata.ApparentWindDir+M_PI); 
					vawind = ubxdata.ApparentWindSpeed;
					// True wind must be computed from apparent wind.
					if (bDisableRollWindCorrectionSailboat)
						psitwind = fmod_2PI(psiawind+theta_mes); // Robot speed and roll not taken into account...
					else
						psitwind = fmod_2PI(atan2(sin(psiawind),cos(roll)*cos(psiawind))+theta_mes); // Robot speed not taken into account, but with roll correction...
				}

				if (ublox.bEnableWIMWD||ublox.bEnableWIMDA)
				{
					// True wind.
					psitwind = fmod_2PI(M_PI/2.0-ubxdata.WindDir+M_PI-angle_env);
					vtwind = ubxdata.WindSpeed;
				}
*/
				LeaveCriticalSection(&StateVariablesCS);
			}
			else
			{
				printf("Connection to a ublox lost.\n");
				bGPSOKublox[deviceid] = FALSE;
				bConnected = FALSE;
				Disconnectublox(&ublox);
				mSleep(100);
			}		
		}

		if (bExit) break;
	}

	bGPSOKublox[deviceid] = FALSE;

	if (ublox.pfSaveFile != NULL)
	{
		fclose(ublox.pfSaveFile); 
		ublox.pfSaveFile = NULL;
	}

	if (bConnected) Disconnectublox(&ublox);

	if (!bExit) bExit = TRUE; // Unexpected program exit...

	return 0;
}