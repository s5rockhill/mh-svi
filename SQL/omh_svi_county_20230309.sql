USE [sde_sviomh];
GO

/****** Object:  StoredProcedure [sde].[create_omhsvi_county]    Script Date: 3/9/2023 3:00:45 PM ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO


-- =============================================
-- Author:		David Rickless (Ryan Davis, Ian Dunn)
-- Create date: 9/25/2020
-- Description:	
-- =============================================
CREATE PROCEDURE [sde].[create_omhsvi_county]
-- Add the parameters for the stored procedure here
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    BEGIN
        PRINT 'Creating OMHSVI table';

        -- Drop if table already exists
        IF OBJECT_ID('sde.omh_svi_county', 'U') IS NOT NULL
            DROP TABLE sde.omh_svi_county;

        --Create the table in the db
        CREATE TABLE [sde].[omh_svi_county]
        (
            [GRASP_ID] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
            [ST] [NVARCHAR](2) NULL,
            [STATE] [NVARCHAR](255) NULL,
            [ST_ABBR] [NVARCHAR](2) NULL,
            [COUNTY] [NVARCHAR](255) NULL,
            [FIPS] [NVARCHAR](255) NULL,
            [LOCATION] [NVARCHAR](255) NULL,
            [AREA_SQMI] [FLOAT] NULL,
            [E_TOTPOP] INT NULL,
            [M_TOTPOP] INT NULL,

            -- Theme 1 Socioeconomic status -> copy from 2018 SVI
            [E_HU] INT NULL,
            [M_HU] INT NULL,
            [E_HH] INT NULL,
            [M_HH] INT NULL,
            [E_POV] INT NULL,
            [M_POV] INT NULL,
            [E_UNEMP] INT NULL,
            [M_UNEMP] INT NULL,
            [E_PCI] INT NULL,
            [M_PCI] INT NULL,
            [E_NOHSDP] INT NULL,
            [M_NOHSDP] INT NULL,

            -- Theme 2 HH Comp and Disability -> copy from 2018 SVI
            [E_AGE65] INT NULL,
            [M_AGE65] INT NULL,
            [E_AGE17] INT NULL,
            [M_AGE17] INT NULL,
            [E_DISABL] INT NULL,
            [M_DISABL] INT NULL,
            [E_SNGPNT] INT NULL,
            [M_SNGPNT] DECIMAL(38, 4) NULL,

            -- Theme 3 Minority status and lang -> replace with new detailed vars
            [E_AIAN] INT NULL,
            [M_AIAN] INT NULL,
            [E_ASIAN] INT NULL,
            [M_ASIAN] INT NULL,
            [E_AFAM] INT NULL,
            [M_AFAM] INT NULL,
            [E_NHPI] INT NULL,
            [M_NHPI] INT NULL,
            [E_HISP] INT NULL,
            [M_HISP] INT NULL,
            [E_SPAN] INT NULL,
            [M_SPAN] INT NULL,
            [E_CHIN] INT NULL,
            [M_CHIN] INT NULL,
            [E_VIET] INT NULL,
            [M_VIET] INT NULL,
            [E_KOR] INT NULL,
            [M_KOR] INT NULL,
            [E_RUS] INT NULL,
            [M_RUS] INT NULL,
            [E_OTHER] INT NULL,
            [M_OTHER] INT NULL,

            -- Theme 4 Housing Type and Tranport -> copy from 2018 SVI
            [E_MUNIT] INT NULL,
            [M_MUNIT] DECIMAL(38, 4) NULL,
            [E_MOBILE] INT NULL,
            [M_MOBILE] INT NULL,
            [E_CROWD] INT NULL,
            [M_CROWD] DECIMAL(38, 4) NULL,
            [E_NOVEH] INT NULL,
            [M_NOVEH] INT NULL,
            [E_GROUPQ] INT NULL,
            [M_GROUPQ] INT NULL,

            -- Theme 5 Health Care Infrastructure, Utilization, and Insurance
            [HOSP] INT NULL,
            [URG] INT NULL,
            [PHARM] INT NULL,
            [PCP] INT NULL,
            [E_UNINSUR] INT NULL,
            [M_UNINSUR] INT NULL,

            --	[MEDICARE] INT NULL,
            -- Immunization
            -- Theme 6 Medical Vulnerability 
            [E_NOINT] INT NULL,
            [M_NOINT] INT NULL,

            --		[EGROCERY] INT NULL,
            --		[ETRANSIT] INT NULL,
            --		[EPHARM] INT NULL,
            --		[EGAS] INT NULL,
            --		[EHEALTH] INT NULL,
            --		[EFDBEV] INT NULL,
            --		[ELEFIRE] INT NULL,
            -- THEME 1 percents
            [EP_POV] DECIMAL(38, 4) NULL,
            [MP_POV] DECIMAL(38, 4) NULL,
            [EP_UNEMP] DECIMAL(38, 4) NULL,
            [MP_UNEMP] DECIMAL(38, 4) NULL,
            [EP_PCI] DECIMAL(38, 4) NULL,
            [MP_PCI] DECIMAL(38, 4) NULL,
            [EP_NOHSDP] DECIMAL(38, 4) NULL,
            [MP_NOHSDP] DECIMAL(38, 4) NULL,

            -- THEME 2 percents
            [EP_AGE65] DECIMAL(38, 4) NULL,
            [MP_AGE65] DECIMAL(38, 4) NULL,
            [EP_AGE17] DECIMAL(38, 4) NULL,
            [MP_AGE17] DECIMAL(38, 4) NULL,
            [EP_DISABL] DECIMAL(38, 4) NULL,
            [MP_DISABL] DECIMAL(38, 4) NULL,
            [EP_SNGPNT] DECIMAL(38, 4) NULL,
            [MP_SNGPNT] DECIMAL(38, 4) NULL,

            -- THEME 3 percents
            [EP_AIAN] DECIMAL(38, 4) NULL,
            [MP_AIAN] DECIMAL(38, 4) NULL,
            [EP_ASIAN] DECIMAL(38, 4) NULL,
            [MP_ASIAN] DECIMAL(38, 4) NULL,
            [EP_AFAM] DECIMAL(38, 4) NULL,
            [MP_AFAM] DECIMAL(38, 4) NULL,
            [EP_NHPI] DECIMAL(38, 4) NULL,
            [MP_NHPI] DECIMAL(38, 4) NULL,
            [EP_HISP] DECIMAL(38, 4) NULL,
            [MP_HISP] DECIMAL(38, 4) NULL,
            [EP_SPAN] DECIMAL(38, 4) NULL,
            [MP_SPAN] DECIMAL(38, 4) NULL,
            [EP_CHIN] DECIMAL(38, 4) NULL,
            [MP_CHIN] DECIMAL(38, 4) NULL,
            [EP_VIET] DECIMAL(38, 4) NULL,
            [MP_VIET] DECIMAL(38, 4) NULL,
            [EP_KOR] DECIMAL(38, 4) NULL,
            [MP_KOR] DECIMAL(38, 4) NULL,
            [EP_RUS] DECIMAL(38, 4) NULL,
            [MP_RUS] DECIMAL(38, 4) NULL,
            [EP_OTHER] DECIMAL(38, 4) NULL,
            [MP_OTHER] DECIMAL(38, 4) NULL,

            -- THEME 4 percents
            [EP_MUNIT] DECIMAL(38, 4) NULL,
            [MP_MUNIT] DECIMAL(38, 4) NULL,
            [EP_MOBILE] DECIMAL(38, 4) NULL,
            [MP_MOBILE] DECIMAL(38, 4) NULL,
            [EP_CROWD] DECIMAL(38, 4) NULL,
            [MP_CROWD] DECIMAL(38, 4) NULL,
            [EP_NOVEH] DECIMAL(38, 4) NULL,
            [MP_NOVEH] DECIMAL(38, 4) NULL,
            [EP_GROUPQ] DECIMAL(38, 4) NULL,
            [MP_GROUPQ] DECIMAL(38, 4) NULL,

            --THEME 5 percents
            [R_HOSP] DECIMAL(38, 4) NULL,
            [R_URG] DECIMAL(38, 4) NULL,
            [R_PHARM] DECIMAL(38, 4) NULL,
            [R_PCP] DECIMAL(38, 4) NULL,
            [EP_UNINSUR] DECIMAL(38, 4) NULL,
            [MP_UNINSUR] DECIMAL(38, 4),

            --	[P_MEDICARE] DECIMAL(38, 4),
            -- THEME 6 rates per 100K or percents
            --		[EP_DISAB] DECIMAL(38, 4) NULL,
            [ER_CARDIO] DECIMAL(38, 4) NULL,
            [ER_DIAB] DECIMAL(38, 4) NULL,
            [ER_OBES] DECIMAL(38, 4) NULL,
            [ER_RESPD] DECIMAL(38, 4) NULL,
            [EP_NOINT] DECIMAL(38, 4) NULL,
            [MP_NOINT] DECIMAL(38, 4) NULL,

            --		[P_EGROCERY] DECIMAL(38, 4) NULL,
            --		[P_ETRANSIT] DECIMAL(38, 4) NULL,
            --		[P_EPHARM] DECIMAL(38, 4) NULL,
            --		[P_EGAS] DECIMAL(38, 4) NULL,
            --		[P_EHEALTH] DECIMAL(38, 4) NULL,
            --		[P_EFDBEV] DECIMAL(38, 4) NULL,
            --		[P_ELEFIRE] DECIMAL(38, 4) NULL,
            -- THEME 1 percentiles
            [EPL_POV] DECIMAL(38, 4) NULL,
            [EPL_UNEMP] DECIMAL(38, 4) NULL,
            [EPL_PCI] DECIMAL(38, 4) NULL,
            [EPL_NOHSDP] DECIMAL(38, 4) NULL,
            [SPL_THEME1] DECIMAL(38, 4) NULL,
            [RPL_THEME1] DECIMAL(38, 4) NULL,

            -- THEME 2 percentiles
            [EPL_AGE65] DECIMAL(38, 4) NULL,
            [EPL_AGE17] DECIMAL(38, 4) NULL,
            [EPL_DISABL] DECIMAL(38, 4) NULL,
            [EPL_SNGPNT] DECIMAL(38, 4) NULL,
            [SPL_THEME2] DECIMAL(38, 4) NULL,
            [RPL_THEME2] DECIMAL(38, 4) NULL,

            -- THEME 3 percentiles
            [EPL_AIAN] DECIMAL(38, 4) NULL,
            [EPL_ASIAN] DECIMAL(38, 4) NULL,
            [EPL_AFAM] DECIMAL(38, 4) NULL,
            [EPL_NHPI] DECIMAL(38, 4) NULL,
            [EPL_HISP] DECIMAL(38, 4) NULL,
            [EPL_SPAN] DECIMAL(38, 4) NULL,
            [EPL_CHIN] DECIMAL(38, 4) NULL,
            [EPL_VIET] DECIMAL(38, 4) NULL,
            [EPL_KOR] DECIMAL(38, 4) NULL,
            [EPL_RUS] DECIMAL(38, 4) NULL,
            [EPL_OTHER] DECIMAL(38, 4) NULL,
            [SPL_THEME3] DECIMAL(38, 4) NULL,
            [RPL_THEME3] DECIMAL(38, 4) NULL,

            -- THEME 4 percentiles
            [EPL_MUNIT] DECIMAL(38, 4) NULL,
            [EPL_MOBILE] DECIMAL(38, 4) NULL,
            [EPL_CROWD] DECIMAL(38, 4) NULL,
            [EPL_NOVEH] DECIMAL(38, 4) NULL,
            [EPL_GROUPQ] DECIMAL(38, 4) NULL,
            [SPL_THEME4] DECIMAL(38, 4) NULL,
            [RPL_THEME4] DECIMAL(38, 4) NULL,

            -- THEME 5percentiles
            [PL_HOSP] DECIMAL(38, 4) NULL,
            [PL_URG] DECIMAL(38, 4) NULL,
            [PL_PHARM] DECIMAL(38, 4) NULL,
            [PL_PCP] DECIMAL(38, 4) NULL,
            [EPL_UNINSUR] DECIMAL(38, 4) NULL,

            --	[PL_MEDICARE] DECIMAL(38, 4),
            [SPL_THEME5] DECIMAL(38, 4) NULL,
            [RPL_THEME5] DECIMAL(38, 4) NULL,

            -- THEME 6 percentiles
            --		[EPL_DISAB] DECIMAL(38, 4) NULL,
            [PL_CARDIO] DECIMAL(38, 4) NULL,
            [PL_DIAB] DECIMAL(38, 4) NULL,
            [PL_OBES] DECIMAL(38, 4) NULL,
            [PL_RESPD] DECIMAL(38, 4) NULL,
            [EPL_NOINT] DECIMAL(38, 4) NULL,

            --		[PL_EGROCERY] DECIMAL(38, 4) NULL,
            --		[PL_ETRANSIT] DECIMAL(38, 4) NULL,
            --		[PL_EPHARM] DECIMAL(38, 4) NULL,
            --		[PL_EGAS] DECIMAL(38, 4) NULL,
            --		[PL_EHEALTH] DECIMAL(38, 4) NULL,
            --		[PL_EFDBEV] DECIMAL(38, 4) NULL,
            --		[PL_ELEFIRE] DECIMAL(38, 4) NULL,
            [SPL_THEME6] DECIMAL(38, 4) NULL,
            [RPL_THEME6] DECIMAL(38, 4) NULL,
            [SPL_THEMES] DECIMAL(38, 4) NULL,
            [RPL_THEMES] DECIMAL(38, 4) NULL,
            [THEME1_CAT] NVARCHAR(255) NULL,
            [THEME2_CAT] NVARCHAR(255) NULL,
            [THEME3_CAT] NVARCHAR(255) NULL,
            [THEME4_CAT] NVARCHAR(255) NULL,
            [THEME5_CAT] NVARCHAR(255) NULL,
            [THEME6_CAT] NVARCHAR(255) NULL,
            [RPL_CAT] NVARCHAR(255) NULL,
            [RPL_Percentile] DECIMAL(38, 1) NULL,
            [pctltheme1] DECIMAL(38, 1) NULL,
            [pctltheme2] DECIMAL(38, 1) NULL,
            [pctltheme3] DECIMAL(38, 1) NULL,
            [pctltheme4] DECIMAL(38, 1) NULL,
            [pctltheme5] DECIMAL(38, 1) NULL,
            [pctltheme6] DECIMAL(38, 1) NULL
        );
    END;

    BEGIN
        /***Begin populating table from Census tables.***/
        PRINT 'Populating SVI table with Census data variables.';

        --Inserts data from S0601_CNTY but only for records that exist in 2018 Census Tract Boundary File
        --This ensures that a FIPS code along with other basic information exists for every tract 
        INSERT INTO sde.omh_svi_county
        (
            [ST],
            [STATE],
            [ST_ABBR],
            COUNTY,
            FIPS,
            [LOCATION],
            AREA_SQMI,
            E_TOTPOP,
            M_TOTPOP
        )
        SELECT cg.STATEFP,
               u.StateNameSpace,
               u.ST_ABBR,
               cg.[NAME],
               a.GEO_ID,
               a.[NAME],
               cg.ALAND * .000000386102,
               a.S0601_C01_001E,
               a.S0601_C01_001M
        FROM sde_grasp_svi_2018.dbo.S0601_county AS a
            INNER JOIN sde_grasp_svi_2018.sde.CB_2018_US_COUNTY_500K AS cg
                ON cg.GEOID = a.GEO_ID
            INNER JOIN sde_grasp_svi_2018.dbo.STATESID AS u
                ON u.STATEFP = cg.STATEFP;;

        PRINT 'Generating Indices';

        -- Add indexes for FIPS and state-related fields
        CREATE UNIQUE NONCLUSTERED INDEX idx_FIPS ON [sde].omh_svi_county (FIPS);

        CREATE NONCLUSTERED INDEX idx_ST ON [sde].omh_svi_county (ST);

        CREATE NONCLUSTERED INDEX idx_STATE ON [sde].omh_svi_county ([ST_ABBR]);

        PRINT 'Updating county names';

        --Update County Name to include City and Bourough if applicable
        --Must happen after County Name and Location fields are added
        UPDATE sde.omh_svi_county
        SET COUNTY = COUNTY + ' City and Borough'
        WHERE LOWER(LOCATION) LIKE '%city and borough%';

        UPDATE sde.omh_svi_county
        SET COUNTY = COUNTY + ' City'
        WHERE LOWER(LOCATION) LIKE '%city%'
              AND LOWER(COUNTY) NOT LIKE '%city%';

        PRINT 'Populating columns with data';

        UPDATE cnty
        SET
            -- Theme 1 Socioeconomic status -> copy from 2018 SVI
            cnty.[E_HU] = svi.[E_HU],
            cnty.[M_HU] = svi.[M_HU],
            cnty.[E_HH] = svi.[E_HH],
            cnty.[M_HH] = svi.[M_HH],
            cnty.[E_POV] = svi.[E_POV],
            cnty.[M_POV] = svi.[M_POV],
            cnty.[E_UNEMP] = svi.[E_UNEMP],
            cnty.[M_UNEMP] = svi.[M_UNEMP],
            cnty.[E_PCI] = svi.[E_PCI],
            cnty.[M_PCI] = svi.[M_PCI],
            cnty.[E_NOHSDP] = svi.[E_NOHSDP],
            cnty.[M_NOHSDP] = svi.[M_NOHSDP],

            -- Theme 2 HH Comp and Disability -> copy from 2018 SVI
            cnty.[E_AGE65] = svi.[E_AGE65],
            cnty.[M_AGE65] = svi.[M_AGE65],
            cnty.[E_AGE17] = svi.[E_AGE17],
            cnty.[M_AGE17] = svi.[M_AGE17],
            cnty.[E_DISABL] = svi.[E_DISABL],
            cnty.[M_DISABL] = svi.[M_DISABL],
            cnty.[E_SNGPNT] = svi.[E_SNGPNT],
            cnty.[M_SNGPNT] = svi.[M_SNGPNT],
            -- Theme 3 Minority status and lang -> replace with new detailed vars
            cnty.[E_AIAN] = CAST(newvars.DP05_0039E AS INT),
            cnty.[M_AIAN] = CAST(newvars.DP05_0039M AS INT),
            cnty.[E_ASIAN] = CAST(newvars.DP05_0044E AS INT),
            cnty.[M_ASIAN] = CAST(newvars.DP05_0044M AS INT),
            cnty.[E_AFAM] = CAST(newvars.DP05_0038E AS INT),
            cnty.[M_AFAM] = CAST(newvars.DP05_0038M AS INT),
            cnty.[E_NHPI] = CAST(newvars.DP05_0052E AS INT),
            cnty.[M_NHPI] = CAST(newvars.DP05_0052M AS INT),
            cnty.[E_HISP] = CAST(newvars.DP05_0071E AS INT),
            cnty.[M_HISP] = CAST(newvars.DP05_0071M AS INT),
            cnty.[E_SPAN] = CAST(newvars.B16001_005E AS INT),
            cnty.[M_SPAN] = CAST(newvars.B16001_005M AS INT),
            cnty.[E_CHIN] = CAST(newvars.B16001_068E AS INT),
            cnty.[M_CHIN] = CAST(newvars.B16001_068M AS INT),
            cnty.[E_VIET] = CAST(newvars.B16001_089E AS INT),
            cnty.[M_VIET] = CAST(newvars.B16001_089M AS INT),
            cnty.[E_KOR] = CAST(newvars.B16001_074E AS INT),
            cnty.[M_KOR] = CAST(newvars.B16001_074M AS INT),
            cnty.[E_RUS] = CAST(newvars.B16001_035E AS INT),
            cnty.[M_RUS] = CAST(newvars.B16001_035M AS INT),
            cnty.[E_OTHER] = CAST(newvars.B02001_007E AS INT),
            cnty.[M_OTHER] = CAST(newvars.B02001_007M AS INT),
            -- Theme 4
            cnty.[E_MUNIT] = svi.[E_MUNIT],
            cnty.[M_MUNIT] = svi.[M_MUNIT],
            cnty.[E_MOBILE] = svi.[E_MOBILE],
            cnty.[M_MOBILE] = svi.[M_MOBILE],
            cnty.[E_CROWD] = svi.[E_CROWD],
            cnty.[M_CROWD] = svi.[M_CROWD],
            cnty.[E_NOVEH] = svi.[E_NOVEH],
            cnty.[M_NOVEH] = svi.[M_NOVEH],
            cnty.[E_GROUPQ] = svi.[E_GROUPQ],
            cnty.[M_GROUPQ] = svi.[M_GROUPQ],
            -- theme 5
            cnty.[HOSP] = CAST(newvars.[Hospitals] AS INT),
            cnty.[URG] = CAST(newvars.[UrgentCare] AS INT),
            cnty.[PHARM] = CAST(newvars.[Pharmacies] AS INT),
            cnty.[PCP] = CAST(newvars.[total_pcp] AS INT),
            cnty.[E_UNINSUR] = CAST(svi.[E_UNINSUR] AS INT),
            cnty.[M_UNINSUR] = CAST(svi.[M_UNINSUR] AS INT),
            --	MEDICARE = CAST(newvars.[MEDICARE] AS INT),
            -- Immunization (state level)
            -- medicaid (state level)
            -- theme 6
            cnty.[E_NOINT] = CAST(newvars.B28002_013E AS INT),
            cnty.[M_NOINT] = CAST(newvars.B28002_013M AS INT),
            --		cnty.[EGROCERY] = CAST(newvars.GROC AS INT), 
            --		cnty.[ETRANSIT] = CAST(newvars.TRANSIT AS INT),
            --		cnty.[EPHARM] = CAST(newvars.PHARM AS INT),
            --		cnty.[EGAS] = CAST(newvars.GAS AS INT),
            --		cnty.[EHEALTH] = CAST(newvars.HEALTH AS INT),
            --		cnty.[EFDBEV] = CAST(newvars.FDBEV AS INT),
            --		cnty.[ELEFIRE] = CAST(newvars.ELEFIRE AS INT),
            -- THEME 1 percents
            cnty.[EP_POV] = svi.EP_POV,
            cnty.[MP_POV] = svi.MP_POV,
            cnty.[EP_UNEMP] = svi.EP_UNEMP,
            cnty.[MP_UNEMP] = svi.MP_UNEMP,
            cnty.[EP_PCI] = svi.EP_PCI,
            cnty.[MP_PCI] = svi.MP_PCI,
            cnty.[EP_NOHSDP] = svi.EP_NOHSDP,
            cnty.[MP_NOHSDP] = svi.MP_NOHSDP,
            -- THEME 2 percents
            cnty.[EP_AGE65] = svi.[EP_AGE65],
            cnty.[MP_AGE65] = svi.[MP_AGE65],
            cnty.[EP_AGE17] = svi.[EP_AGE17],
            cnty.[MP_AGE17] = svi.[MP_AGE17],
            cnty.[EP_DISABL] = svi.[EP_DISABL],
            cnty.[MP_DISABL] = svi.[MP_DISABL],
            cnty.[EP_SNGPNT] = svi.[EP_SNGPNT],
            cnty.[MP_SNGPNT] = svi.[MP_SNGPNT],

            -- THEME 3 percents
            cnty.[EP_AIAN] = CAST(newvars.DP05_0039PE AS DECIMAL(38, 4)),
            cnty.[MP_AIAN] = CAST(newvars.DP05_0039PM AS DECIMAL(38, 4)),
            cnty.[EP_ASIAN] = CAST(newvars.DP05_0044PE AS DECIMAL(38, 4)),
            cnty.[MP_ASIAN] = CAST(newvars.DP05_0044PM AS DECIMAL(38, 4)),
            cnty.[EP_AFAM] = CAST(newvars.DP05_0038PE AS DECIMAL(38, 4)),
            cnty.[MP_AFAM] = CAST(newvars.DP05_0038PM AS DECIMAL(38, 4)),
            cnty.[EP_NHPI] = CAST(newvars.DP05_0052PE AS DECIMAL(38, 4)),
            cnty.[MP_NHPI] = CAST(newvars.DP05_0052PM AS DECIMAL(38, 4)),
            cnty.[EP_HISP] = CAST(newvars.DP05_0071PE AS DECIMAL(38, 4)),
            cnty.[MP_HISP] = CAST(newvars.DP05_0071PM AS DECIMAL(38, 4)),
            cnty.[EP_SPAN] = CAST(newvars.B16001_005PE AS DECIMAL(38, 4)),
            cnty.[MP_SPAN] = CAST(newvars.B16001_005PM AS DECIMAL(38, 4)),
            cnty.[EP_CHIN] = CAST(newvars.B16001_068PE AS DECIMAL(38, 4)),
            cnty.[MP_CHIN] = CAST(newvars.B16001_068PM AS DECIMAL(38, 4)),
            cnty.[EP_VIET] = CAST(newvars.B16001_089PE AS DECIMAL(38, 4)),
            cnty.[MP_VIET] = CAST(newvars.B16001_089PM AS DECIMAL(38, 4)),
            cnty.[EP_KOR] = CAST(newvars.B16001_074PE AS DECIMAL(38, 4)),
            cnty.[MP_KOR] = CAST(newvars.B16001_074PM AS DECIMAL(38, 4)),
            cnty.[EP_RUS] = CAST(newvars.B16001_035PE AS DECIMAL(38, 4)),
            cnty.[MP_RUS] = CAST(newvars.B16001_035PM AS DECIMAL(38, 4)),
            cnty.[EP_OTHER] = CAST(newvars.B02001_007PE AS DECIMAL(38, 4)),
            cnty.[MP_OTHER] = CAST(newvars.B02001_007PM AS DECIMAL(38, 4)),
            -- THEME 4 percents
            cnty.[EP_MUNIT] = svi.[EP_MUNIT],
            cnty.[MP_MUNIT] = svi.[MP_MUNIT],
            cnty.[EP_MOBILE] = svi.[EP_MOBILE],
            cnty.[MP_MOBILE] = svi.[MP_MOBILE],
            cnty.[EP_CROWD] = svi.[EP_CROWD],
            cnty.[MP_CROWD] = svi.[MP_CROWD],
            cnty.[EP_NOVEH] = svi.[EP_NOVEH],
            cnty.[MP_NOVEH] = svi.[MP_NOVEH],
            cnty.[EP_GROUPQ] = svi.[EP_GROUPQ],
            cnty.[MP_GROUPQ] = svi.[MP_GROUPQ],

            --THEME 5 percents
            -- Count of facilities is derived from Summarize Within function in ArcGIS Pro.
            -- Rate is calulated using SVI variable E_TOTPOP as denominator, * 100K to get rate per 100K
            cnty.[R_HOSP] = CAST(newvars.hosp_rate AS DECIMAL(38, 4)),
            cnty.[R_URG] = CAST(newvars.urg_rate AS DECIMAL(38, 4)),
            cnty.[R_PHARM] = CAST(newvars.pharm_rate AS DECIMAL(38, 4)),
            cnty.[R_PCP] = CAST(newvars.R_PCP AS DECIMAL(38, 4)),
            cnty.[EP_UNINSUR] = CAST(svi.EP_UNINSUR AS DECIMAL(38, 4)),
            cnty.[MP_UNINSUR] = CAST(svi.MP_UNINSUR AS DECIMAL(38, 4)),

            --		cnty.P_MEDICARE = CAST(newvars.medicare_percap AS DECIMAL),
            -- THEME 6 rates per 100K
            --		cnty.[EP_DISAB] = CAST(covsvi.[EP_DISABL] AS DECIMAL(38, 4)),
            cnty.[ER_CARDIO] = CAST(covsvi.[ER_CARDIO] AS DECIMAL(38, 4)),
            cnty.[ER_DIAB] = CAST(covsvi.[EP_DIAB] * 1000 AS DECIMAL(38, 4)),
            cnty.[ER_OBES] = CAST(covsvi.[EP_OBES] * 1000 AS DECIMAL(38, 4)),
            cnty.[ER_RESPD] = CAST(covsvi.ER_RESPD AS DECIMAL(38, 4)),
            cnty.[EP_NOINT] = CAST(newvars.B28002_013PE AS DECIMAL(38, 4)),
            cnty.[MP_NOINT] = CAST(newvars.B28002_013PM AS DECIMAL(38, 4)),

            --		cnty.[P_EGROCERY] = CAST(newvars.P_GROC AS DECIMAL(38, 4)),
            --		cnty.[P_ETRANSIT] = CAST(newvars.P_TRANSIT AS DECIMAL(38, 4)),
            --		cnty.[P_EPHARM] = CAST(newvars.P_PHARM AS DECIMAL(38, 4)),
            --		cnty.[P_EGAS] = CAST(newvars.P_GAS AS DECIMAL(38, 4)),
            --		cnty.[P_EHEALTH] = CAST(newvars.P_HEALTH AS DECIMAL(38, 4)),
            --		cnty.[P_EFDBEV] = CAST(newvars.P_FDBEV AS DECIMAL(38, 4)),
            --		cnty.[P_ELEFIRE] = CAST(newvars.P_ELEFIRE AS DECIMAL(38, 4)),
            -- THEME 1 percentiles
            cnty.[EPL_POV] = svi.[EPL_POV],
            cnty.[EPL_UNEMP] = svi.[EPL_UNEMP],
            cnty.[EPL_PCI] = svi.[EPL_PCI],
            cnty.[EPL_NOHSDP] = svi.[EPL_NOHSDP],
            cnty.[SPL_THEME1] = svi.[SPL_THEME1],
            cnty.[RPL_THEME1] = svi.[RPL_THEME1],

            -- THEME 2 percentiles
            cnty.[EPL_AGE65] = svi.[EPL_AGE65],
            cnty.[EPL_AGE17] = svi.[EPL_AGE17],
            cnty.[EPL_DISABL] = svi.[EPL_DISABL],
            cnty.[EPL_SNGPNT] = svi.[EPL_SNGPNT],
            cnty.[SPL_THEME2] = svi.[SPL_THEME2],
            cnty.[RPL_THEME2] = svi.[RPL_THEME2],

            -- THEME 3 percentiles
            cnty.[EPL_AIAN] = CAST(newvars.DP05_0039EPL AS DECIMAL(38, 4)),
            cnty.[EPL_ASIAN] = CAST(newvars.DP05_0044EPL AS DECIMAL(38, 4)),
            cnty.[EPL_AFAM] = CAST(newvars.DP05_0038EPL AS DECIMAL(38, 4)),
            cnty.[EPL_HISP] = CAST(newvars.DP05_0071EPL AS DECIMAL(38, 4)),
            cnty.[EPL_NHPI] = CAST(newvars.DP05_0052EPL AS DECIMAL(38, 4)),
            [EPL_SPAN] = CAST(newvars.B16001_005EPL AS DECIMAL(38, 4)),
            cnty.[EPL_CHIN] = CAST(newvars.B16001_068EPL AS DECIMAL(38, 4)),
            cnty.[EPL_VIET] = CAST(newvars.B16001_089EPL AS DECIMAL(38, 4)),
            cnty.[EPL_KOR] = CAST(newvars.B16001_074EPL AS DECIMAL(38, 4)),
            cnty.[EPL_RUS] = CAST(newvars.B16001_035EPL AS DECIMAL(38, 4)),
            cnty.[EPL_OTHER] = CAST(newvars.B02001_007EPL AS DECIMAL(38, 4)),
            -- THEME 4 percentiles
            cnty.[EPL_MUNIT] = svi.[EPL_MUNIT],
            cnty.[EPL_MOBILE] = svi.[EPL_MOBILE],
            cnty.[EPL_CROWD] = svi.[EPL_CROWD],
            cnty.[EPL_NOVEH] = svi.[EPL_NOVEH],
            cnty.[EPL_GROUPQ] = svi.[EPL_GROUPQ],
            cnty.[SPL_THEME4] = svi.[SPL_THEME4],
            cnty.[RPL_THEME4] = svi.[RPL_THEME4],
            -- THEME 5percentiles
            -- reverse directionality for facilities (more facilities = less vulnerable)
            cnty.[PL_HOSP] = 1 - CAST(newvars.hosp_pl AS DECIMAL(38, 4)),
            cnty.[PL_URG] = 1 - CAST(newvars.urg_pl AS DECIMAL(38, 4)),
            cnty.[PL_PHARM] = 1 - CAST(newvars.pharm_pl AS DECIMAL(38, 4)),
            cnty.[PL_PCP] = 1 - CAST(newvars.PL_PCP AS DECIMAL(38, 4)),
            cnty.[EPL_UNINSUR] = CAST(covsvi.EPL_UNINS AS DECIMAL(38, 4)),
            --	cnty.PL_MEDICARE = newvars.medicare_pl,
            -- THEME 6 percentiles
            --		cnty.[EPL_DISAB] = CAST(covsvi.EPL_DISABL AS DECIMAL(38, 4)),
            cnty.[PL_CARDIO] = CAST(covsvi.[EPLCARDIO] AS DECIMAL(38, 4)),
            cnty.[PL_DIAB] = CAST(covsvi.[EPL_DIAB] AS DECIMAL(38, 4)),
            cnty.[PL_OBES] = CAST(covsvi.[EPL_OBES] AS DECIMAL(38, 4)),
            cnty.[PL_RESPD] = CAST(covsvi.[EPL_RESPD] AS DECIMAL(38, 4)),
            cnty.[EPL_NOINT] = CAST(newvars.[B28002_013EPL] AS DECIMAL(38, 4))
        --		cnty.[PL_EGROCERY] = CAST(newvars.PL_GROC AS DECIMAL(38, 4)), 
        --		cnty.[PL_ETRANSIT] = CAST(newvars.PL_TRANSIT AS DECIMAL(38, 4)), 
        --		cnty.[PL_EPHARM] = CAST(newvars.PL_PHARM AS DECIMAL(38, 4)), 
        --		cnty.[PL_EGAS] = CAST(newvars.PL_GAS AS DECIMAL(38, 4)), 
        --		cnty.[PL_EHEALTH] = CAST(newvars.PL_HEALTH AS DECIMAL(38, 4)),
        --		cnty.[PL_EFDBEV] = CAST(newvars.PL_FDBEV AS DECIMAL(38, 4)),
        --		cnty.[PL_ELEFIRE] = CAST(newvars.PL_ELEFIRE AS DECIMAL(38, 4))
        FROM sde.omh_svi_county AS cnty
            INNER JOIN dbo.omh_svi_newvars AS newvars
                ON newvars.GEOID = cnty.FIPS
            INNER JOIN sde_cov19.dbo.COVIDSVI2018_COUNTY AS covsvi
                ON covsvi.FIPS = cnty.FIPS
            INNER JOIN sde_grasp_svi_2018.sde.SVI2018_US_county AS svi
                ON svi.FIPS = cnty.FIPS;
    END;

    -- totals/rankings for themes 3, 5, and 6
    BEGIN
        PRINT 'Totaling percentile rankings for new themes.';

        UPDATE omh_svi_county
        SET SPL_THEME3 = CASE
                             WHEN
                             (
                                 EPL_AIAN <> -999
                                 AND EPL_ASIAN <> -999
                                 AND EPL_AFAM <> -999
                                 AND EPL_NHPI <> -999
                                 AND EPL_HISP <> -999
                                 AND EPL_SPAN <> -999
                                 AND EPL_CHIN <> -999
                                 AND EPL_VIET <> -999
                                 AND EPL_KOR <> -999
                                 AND EPL_RUS <> -999
                                 AND EPL_OTHER <> -999
                             ) THEN
                                 EPL_AIAN + EPL_ASIAN + EPL_AFAM + EPL_NHPI + EPL_HISP + EPL_SPAN + EPL_CHIN + EPL_VIET
                                 + EPL_KOR + EPL_RUS + EPL_OTHER
                             ELSE
                                 -999
                         END,
            SPL_THEME5 = CASE
                             WHEN
                             (
                                 PL_HOSP <> -999
                                 AND PL_URG <> -999
                                 AND PL_PHARM <> -999
                                 AND PL_PCP <> -999
                                 AND EPL_UNINSUR <> -999
                             --	AND PL_MEDICARE <> -999
                             ) THEN
                                 PL_HOSP + PL_URG + PL_PHARM + PL_PCP + EPL_UNINSUR
                             ELSE
                                 -999
                         END,
            SPL_THEME6 = CASE
                             WHEN
                             (
                                 PL_CARDIO <> -999
                                 AND PL_DIAB <> -999
                                 AND PL_OBES <> -999
                                 AND PL_RESPD <> -999
                                 AND EPL_NOINT <> -999
                             --AND PL_EGROCERY <> -999
                             --AND PL_ETRANSIT <> -999
                             --AND PL_EPHARM <> -999
                             --AND PL_EGAS <> -999
                             --AND PL_EHEALTH <> -999
                             --AND PL_EFDBEV <> -999
                             --AND PL_ELEFIRE <> -999
                             ) THEN
                                 PL_CARDIO + PL_DIAB + PL_OBES + PL_RESPD + EPL_NOINT
                             ELSE
                                 -999
                         END
        FROM sde.omh_svi_county;
    --End Calculate SPLs
    END;

    BEGIN
        --Calculate Theme Ranks
        PRINT 'Calculating new theme percentile rankings.';

        WITH THEME3_CTE
        AS (SELECT FIPS AS FIPS,
                   RPL_THEME3,
                   CAST(PERCENT_RANK() OVER (ORDER BY SPL_THEME3) AS DECIMAL(38, 4)) AS RPL_THEME3_CTE
            FROM sde.omh_svi_county
            WHERE E_TOTPOP > 0
                  AND SPL_THEME3 <> -999)
        UPDATE THEME3_CTE
        SET RPL_THEME3 = RPL_THEME3_CTE
        WHERE 1 = 1;

        UPDATE sde.omh_svi_county
        SET RPL_THEME3 = -999
        WHERE SPL_THEME3 = -999;

        WITH THEME5_CTE
        AS (SELECT FIPS AS FIPS,
                   RPL_THEME5,
                   CONVERT(DECIMAL(38, 4), PERCENT_RANK() OVER (ORDER BY SPL_THEME5)) AS RPL_THEME5_CTE
            FROM sde.omh_svi_county
            WHERE E_TOTPOP > 0
                  AND SPL_THEME5 <> -999)
        UPDATE THEME5_CTE
        SET RPL_THEME5 = RPL_THEME5_CTE
        WHERE 1 = 1;

        UPDATE sde.omh_svi_county
        SET RPL_THEME5 = -999
        WHERE SPL_THEME5 = -999;

        WITH THEME6_CTE
        AS (SELECT FIPS AS FIPS,
                   RPL_THEME6,
                   CONVERT(DECIMAL(38, 4), PERCENT_RANK() OVER (ORDER BY SPL_THEME6)) AS RPL_THEME6_CTE
            FROM sde.omh_svi_county
            WHERE E_TOTPOP > 0
                  AND SPL_THEME6 <> -999)
        UPDATE THEME6_CTE
        SET RPL_THEME6 = RPL_THEME6_CTE
        WHERE 1 = 1;

        UPDATE sde.omh_svi_county
        SET RPL_THEME6 = -999
        WHERE SPL_THEME6 = -999;
    --End Calculate Theme Ranks
    END;

    BEGIN
        PRINT 'Totaling SPL_THEMES';

        --Set SPL_THEMES
        UPDATE sde.omh_svi_county
        SET SPL_THEMES = CASE
                             WHEN
                             (
                                 SPL_THEME1 <> -999
                                 AND SPL_THEME2 <> -999
                                 AND SPL_THEME3 <> -999
                                 AND SPL_THEME4 <> -999
                                 AND SPL_THEME5 <> -999
                                 AND SPL_THEME6 <> -999
                             ) THEN
                                 SPL_THEME1 + SPL_THEME2 + SPL_THEME3 + SPL_THEME4 + SPL_THEME5 + SPL_THEME6
                             ELSE
                                 -999
                         END
        WHERE 1 = 1;
    --End Set SPL_THEMES
    END;

    BEGIN
        --Calculate Overall Percentile Rankings using formula
        PRINT 'Calculating overall percentile rankings';

        WITH ALL_PercentRank_CTE
        AS (SELECT FIPS AS FIPS,
                   RPL_THEMES,
                   CAST(PERCENT_RANK() OVER (ORDER BY SPL_THEMES) AS DECIMAL(38, 4)) AS RPL_THEMES_CTE
            FROM sde.omh_svi_county
            WHERE E_TOTPOP > 0
                  AND SPL_THEMES <> -999)
        UPDATE ALL_PercentRank_CTE
        SET RPL_THEMES = RPL_THEMES_CTE
        WHERE 1 = 1;

        UPDATE sde.omh_svi_county
        SET RPL_THEMES = -999,
            RPL_Percentile = -999
        WHERE SPL_THEMES = -999;

        UPDATE sde.omh_svi_county
        SET RPL_Percentile = RPL_THEMES * 100,
            pctltheme1 = RPL_THEME1 * 100,
            pctltheme2 = RPL_THEME2 * 100,
            pctltheme3 = RPL_THEME3 * 100,
            pctltheme4 = RPL_THEME4 * 100,
            pctltheme5 = RPL_THEME5 * 100,
            pctltheme6 = RPL_THEME6 * 100
        WHERE RPL_THEMES <> -999;
    --End Calculate Overall Percentile Rankings

    END;

    BEGIN
        --Calculate cateogrical values for rankings
        PRINT 'Calculating categories';

        UPDATE sde.omh_svi_county
        SET RPL_CAT = CASE
                          WHEN RPL_THEMES < 0.25 THEN
                              'Low'
                          WHEN
                          (
                              RPL_THEMES >= 0.25
                              AND RPL_THEMES < 0.5
                          ) THEN
                              'Medium Low'
                          WHEN
                          (
                              RPL_THEMES >= 0.5
                              AND RPL_THEMES < 0.75
                          ) THEN
                              'Medium High'
                          ELSE
                              'High'
                      END,
            THEME1_CAT = CASE
                             WHEN RPL_THEME1 < 0.25 THEN
                                 'Low'
                             WHEN
                             (
                                 RPL_THEME1 >= 0.25
                                 AND RPL_THEME1 < 0.5
                             ) THEN
                                 'Medium Low'
                             WHEN
                             (
                                 RPL_THEME1 >= 0.5
                                 AND RPL_THEME1 < 0.75
                             ) THEN
                                 'Medium High'
                             ELSE
                                 'High'
                         END,
            THEME2_CAT = CASE
                             WHEN RPL_THEME2 < 0.25 THEN
                                 'Low'
                             WHEN
                             (
                                 RPL_THEME2 >= 0.25
                                 AND RPL_THEME2 < 0.5
                             ) THEN
                                 'Medium Low'
                             WHEN
                             (
                                 RPL_THEME2 >= 0.5
                                 AND RPL_THEME2 < 0.75
                             ) THEN
                                 'Medium High'
                             ELSE
                                 'High'
                         END,
            THEME3_CAT = CASE
                             WHEN RPL_THEME3 < 0.25 THEN
                                 'Low'
                             WHEN
                             (
                                 RPL_THEME3 >= 0.25
                                 AND RPL_THEME3 < 0.5
                             ) THEN
                                 'Medium Low'
                             WHEN
                             (
                                 RPL_THEME3 >= 0.5
                                 AND RPL_THEME3 < 0.75
                             ) THEN
                                 'Medium High'
                             ELSE
                                 'High'
                         END,
            THEME4_CAT = CASE
                             WHEN RPL_THEME4 < 0.25 THEN
                                 'Low'
                             WHEN
                             (
                                 RPL_THEME4 >= 0.25
                                 AND RPL_THEME4 < 0.5
                             ) THEN
                                 'Medium Low'
                             WHEN
                             (
                                 RPL_THEME4 >= 0.5
                                 AND RPL_THEME4 < 0.75
                             ) THEN
                                 'Medium High'
                             ELSE
                                 'High'
                         END,
            THEME5_CAT = CASE
                             WHEN RPL_THEME5 < 0.25 THEN
                                 'Low'
                             WHEN
                             (
                                 RPL_THEME5 >= 0.25
                                 AND RPL_THEME5 < 0.5
                             ) THEN
                                 'Medium Low'
                             WHEN
                             (
                                 RPL_THEME5 >= 0.5
                                 AND RPL_THEME5 < 0.75
                             ) THEN
                                 'Medium High'
                             ELSE
                                 'High'
                         END,
            THEME6_CAT = CASE
                             WHEN RPL_THEME6 < 0.25 THEN
                                 'Low'
                             WHEN
                             (
                                 RPL_THEME6 >= 0.25
                                 AND RPL_THEME6 < 0.5
                             ) THEN
                                 'Medium Low'
                             WHEN
                             (
                                 RPL_THEME6 >= 0.5
                                 AND RPL_THEME6 < 0.75
                             ) THEN
                                 'Medium High'
                             ELSE
                                 'High'
                         END;
    END;
END;

BEGIN
    PRINT 'Creating indexes';
    /*
	--Create the spatial index for the new dataset so it draws faster
	CREATE SPATIAL INDEX SP_Index ON sde.omh_svi_county (Shape) USING GEOMETRY_AUTO_GRID
		WITH (
				BOUNDING_BOX = (
					- 179.148909
					,- 14.548699
					,179.77847
					,71.365162
					)
				,CELLS_PER_OBJECT = 16
				,PAD_INDEX = OFF
				,FILLFACTOR = 100
				,SORT_IN_TEMPDB = OFF
				,IGNORE_DUP_KEY = OFF
				,STATISTICS_NORECOMPUTE = OFF
				,DROP_EXISTING = OFF
				,ONLINE = OFF
				,ALLOW_ROW_LOCKS = ON
				,ALLOW_PAGE_LOCKS = ON
				,MAXDOP = 0
				,DATA_COMPRESSION = NONE
				);
*/
    --Create attribute indexes
    CREATE NONCLUSTERED INDEX EPL_POV ON [sde].[omh_svi_county] (EPL_POV);

    CREATE NONCLUSTERED INDEX EPL_UNEMP
    ON [sde].[omh_svi_county] (EPL_UNEMP);

    CREATE NONCLUSTERED INDEX EPL_PCI ON [sde].[omh_svi_county] (EPL_PCI);

    CREATE NONCLUSTERED INDEX EPL_NOHSDP
    ON [sde].[omh_svi_county] (EPL_NOHSDP);

    CREATE NONCLUSTERED INDEX SPL_THEME1
    ON [sde].[omh_svi_county] (SPL_THEME1);

    CREATE NONCLUSTERED INDEX RPL_THEME1
    ON [sde].[omh_svi_county] (RPL_THEME1);

    CREATE NONCLUSTERED INDEX EPL_AGE65
    ON [sde].[omh_svi_county] (EPL_AGE65);

    CREATE NONCLUSTERED INDEX EPL_AGE17
    ON [sde].[omh_svi_county] (EPL_AGE17);

    CREATE NONCLUSTERED INDEX EPL_DISABL
    ON [sde].[omh_svi_county] (EPL_DISABL);

    CREATE NONCLUSTERED INDEX EPL_SNGPNT
    ON [sde].[omh_svi_county] (EPL_SNGPNT);

    CREATE NONCLUSTERED INDEX SPL_THEME2
    ON [sde].[omh_svi_county] (SPL_THEME2);

    CREATE NONCLUSTERED INDEX RPL_THEME2
    ON [sde].[omh_svi_county] (RPL_THEME2);

    CREATE NONCLUSTERED INDEX EPL_AIAN ON [sde].[omh_svi_county] (EPL_AIAN);

    CREATE NONCLUSTERED INDEX EPL_AFAM ON [sde].[omh_svi_county] (EPL_AFAM);

    CREATE NONCLUSTERED INDEX EPL_HISP ON [sde].[omh_svi_county] (EPL_HISP);

    CREATE NONCLUSTERED INDEX EPL_NHPI ON [sde].[omh_svi_county] (EPL_NHPI);

    CREATE NONCLUSTERED INDEX EPL_SPAN ON [sde].[omh_svi_county] (EPL_SPAN);

    CREATE NONCLUSTERED INDEX EPL_CHIN ON [sde].[omh_svi_county] (EPL_CHIN);

    CREATE NONCLUSTERED INDEX EPL_VIET ON [sde].[omh_svi_county] (EPL_VIET);

    CREATE NONCLUSTERED INDEX EPL_KOR ON [sde].[omh_svi_county] (EPL_KOR);

    CREATE NONCLUSTERED INDEX EPL_RUS ON [sde].[omh_svi_county] (EPL_RUS);

    CREATE NONCLUSTERED INDEX EPL_ASIAN
    ON [sde].[omh_svi_county] (EPL_ASIAN);

    CREATE NONCLUSTERED INDEX SPL_THEME3
    ON [sde].[omh_svi_county] (SPL_THEME3);

    CREATE NONCLUSTERED INDEX RPL_THEME3
    ON [sde].[omh_svi_county] (RPL_THEME3);

    CREATE NONCLUSTERED INDEX EPL_MUNIT
    ON [sde].[omh_svi_county] (EPL_MUNIT);

    CREATE NONCLUSTERED INDEX EPL_MOBILE
    ON [sde].[omh_svi_county] (EPL_MOBILE);

    CREATE NONCLUSTERED INDEX EPL_CROWD
    ON [sde].[omh_svi_county] (EPL_CROWD);

    CREATE NONCLUSTERED INDEX EPL_NOVEH
    ON [sde].[omh_svi_county] (EPL_NOVEH);

    CREATE NONCLUSTERED INDEX EPL_GROUPQ
    ON [sde].[omh_svi_county] (EPL_GROUPQ);

    CREATE NONCLUSTERED INDEX SPL_THEME4
    ON [sde].[omh_svi_county] (SPL_THEME4);

    CREATE NONCLUSTERED INDEX RPL_THEME4
    ON [sde].[omh_svi_county] (RPL_THEME4);

    CREATE NONCLUSTERED INDEX PL_HOSP ON [sde].[omh_svi_county] (PL_HOSP);

    CREATE NONCLUSTERED INDEX PL_URG ON [sde].[omh_svi_county] (PL_URG);

    CREATE NONCLUSTERED INDEX PL_PCP ON [sde].[omh_svi_county] (PL_PCP);

    CREATE NONCLUSTERED INDEX EPL_UNINSUR
    ON [sde].[omh_svi_county] (EPL_UNINSUR);

    CREATE NONCLUSTERED INDEX PL_PHARM ON [sde].[omh_svi_county] (PL_PHARM);

    CREATE NONCLUSTERED INDEX SPL_THEME5
    ON [sde].[omh_svi_county] (SPL_THEME5);

    CREATE NONCLUSTERED INDEX RPL_THEME5
    ON [sde].[omh_svi_county] (RPL_THEME5);

    CREATE NONCLUSTERED INDEX PL_DIAB ON [sde].[omh_svi_county] (PL_DIAB);

    CREATE NONCLUSTERED INDEX PL_OBES ON [sde].[omh_svi_county] (PL_OBES);

    CREATE NONCLUSTERED INDEX PL_RESPD ON [sde].[omh_svi_county] (PL_RESPD);

    CREATE NONCLUSTERED INDEX EPL_NOINT
    ON [sde].[omh_svi_county] (EPL_NOINT);

    CREATE NONCLUSTERED INDEX SPL_THEME6
    ON [sde].[omh_svi_county] (SPL_THEME6);

    CREATE NONCLUSTERED INDEX RPL_THEME6
    ON [sde].[omh_svi_county] (RPL_THEME6);

    CREATE NONCLUSTERED INDEX SPL_THEMES
    ON [sde].[omh_svi_county] (SPL_THEMES);

    CREATE NONCLUSTERED INDEX RPL_THEMES
    ON [sde].[omh_svi_county] (RPL_THEMES);
END;
GO


