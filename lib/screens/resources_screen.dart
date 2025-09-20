import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:somos_qr_plus/helpers/route_helper.dart';
import '../widgets/app_header_widget.dart';
import '../widgets/app_drawer_widget.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  bool _isDrawerOpen = false;
  bool _showLogoutDialog = false;

  // Quality card state
  bool _isQualityExpanded = false;
  String _qualitySearchQuery = '';

  // Risk Adjustments card state
  bool _isRiskExpanded = false;
  String _riskSearchQuery = '';

  // Quality items data
  final List<Map<String, dynamic>> _qualityItems = [
    {
      'title': 'ANNUAL WELLNESS VISIT',
      'sections': [
        {
          'title': 'MEDICAID',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'Z00.00',
                  'description': 'Adult examination without abnormal findings'
                },
                {
                  'code': 'Z00.01',
                  'description': 'Adult examination with abnormal findings'
                },
              ]
            }
          ]
        },
        {
          'title': 'MEDICARE',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'G0402',
                  'description':
                      'Patient New to Medicare within the last 12 months / Initial Preventive Physical Exam (IPPE)'
                },
                {
                  'code': 'G0438',
                  'description': 'Annual Wellness visit (AWV) -first visit'
                },
                {
                  'code': 'G0439',
                  'description':
                      'All subsequent visits (Includes personalized prevention plan of services)'
                },
                {
                  'code': '99381-99397',
                  'description':
                      'Annual Routine Physical (ARP) - Visit is not problem-oriented and does not involve present illness'
                },
              ]
            }
          ]
        },
        {
          'title':
              'MEDICATION ADHERENCE-CHOLESTEROL, DIABETES, AND HYPERTENSION MEDICATIONS',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'NULL',
                  'description': 'Cholesterol Medications: Statin medications.'
                },
                {
                  'code': 'NULL',
                  'description':
                      'Diabetes medications: (biguanide, sulfonylurea, thiazolidinedione, DPP-4 inhibitor, GLP-1 agonist, meglitinide, or SLGT2 inhibitor).'
                },
                {
                  'code': 'NULL',
                  'description':
                      'Hypertension Medications: Renin angiotensin system (RAS) antagonist medications (ACE inhibitor or ARB)'
                },
              ]
            }
          ]
        },
      ]
    },
    {
      'title': 'CARE OF OLDER ADULT COA',
      'sections': [
        {
          'title': 'Document Results',
          'items': [
            {
              'code': '1170F',
              'description': 'Documentation of Functional Assessment'
            },
            {'code': '1160F', 'description': 'Medication Review'},
            {'code': '3288F', 'description': 'Fall Assessment (Not required)'},
            {
              'code': '1494F',
              'description': 'Cognitive Assessment (Not required)'
            },
            {
              'code': '1090F',
              'description': 'Urinary Assessment (Not required)'
            },
            {'code': '1125F', 'description': 'Pain Level 1-10 documented'},
            {'code': '1126F', 'description': 'No Pain'},
            {'code': '1159F', 'description': 'Medication list exists'},
            {'code': '1160F', 'description': 'Medication list reconciled'},
          ]
        },
      ]
    },
    {
      'title': 'CHLAMYDIA',
      'sections': [
        {
          'title': 'Document Results',
          'items': [
            {'code': 'Z11.9 or Z01.812, G9820', 'description': ''},
          ]
        },
      ]
    },
    {
      'title': 'COLON CANCER SCREENING',
      'sections': [
        {
          'title': 'Document Results',
          'items': [
            {'code': 'Z12.11,82270', 'description': 'Annual FOBT'},
            {'code': '3017F', 'description': 'Results Reviewed & Doc.'},
            {'code': 'Z90.49', 'description': 'Total Colectomy'},
            {'code': 'C18.9', 'description': 'Colon cancer'},
            {'code': 'Z85.038', 'description': 'Per HX Colon Cancer'},
          ]
        },
      ]
    },
    {
      'title': 'DEPRESSION SCREENING',
      'sections': [
        {
          'title': 'Document Results',
          'items': [
            {'code': 'G8510', 'description': 'Scr Result is Negative'},
            {'code': 'G8431', 'description': 'Scr Result is Positive'},
            {
              'code': 'Z13.31',
              'description': 'Enc for screening for depression'
            },
          ]
        },
      ]
    },
    {
      'title': 'DIABETES',
      'sections': [
        {
          'title': 'DIABETIC EYE EXAM',
          'items': [
            {
              'code': '3072F',
              'description':
                  'EED without Evidence of Retinopathy in Prior Year.'
            },
            {
              'code': '2023F, 2025F, 2033F',
              'description': 'EED without Evidence of Retinopathy.'
            },
            {
              'code': '2022F, 2024F, 2026F',
              'description': 'EED with Evidence of Retinopathy'
            },
          ]
        },
        {
          'title': 'HGBA1C',
          'items': [
            {'code': '3044F', 'description': '<7.0'},
            {'code': '3051F', 'description': '7-8'},
            {'code': '3052F', 'description': '>= 8.0 or <9.0'},
            {'code': '3046F', 'description': '>9.0'},
          ]
        },
        {
          'title': 'KIDNEY HEALTH EVALUATION',
          'items': [
            {
              'code': 'eGFR',
              'description': 'estimated glomerular filtration rate'
            },
            {'code': 'uACR', 'description': 'urine albumin-creatinine ratio'},
            {
              'code': '3060F',
              'description': '(+) Microalbuminuria test result doc & reviewed'
            },
            {
              'code': '3061F',
              'description': '(-) Microalbuminuria test result doc & reviewed'
            },
            {
              'code': '3066F',
              'description':
                  'Doc of treatment for Nephropathy (e.g., Dialysis, treated for ESRD, CRF...)'
            },
          ]
        },
      ]
    },
    {
      'title': 'HIV VIRAL LOAD TEST',
      'sections': [
        {
          'title': 'Document Results',
          'items': [
            {
              'code': 'G9242',
              'description': '? 200 copies/mL or not performed'
            },
            {'code': 'G9243', 'description': '<200 copies/mL'},
          ]
        },
      ]
    },
    {
      'title': 'MAMMOGRAM',
      'sections': [
        {
          'title': 'Document Results',
          'items': [
            {'code': 'Z12.31, 3014F', 'description': 'Results Reviewed & Doc'},
            {
              'code': 'Z80.3',
              'description': '(+) FmHx BreastCA (Family History Breast Cancer)'
            },
            {
              'code': 'Z85.3',
              'description':
                  'Per HXBreastCancer (Personal History Breast Cancer)'
            },
            {'code': 'Z90.13', 'description': 'Bilateral Mastectomy'},
          ]
        },
      ]
    },
    {
      'title': 'PAP SMEAR',
      'sections': [
        {
          'title': 'Document Results',
          'items': [
            {
              'code': 'HPV test: 87624, 87625',
              'description':
                  'obtaining, preparing & conveyance of cervical or vagina smear to laboratory'
            },
            {'code': '3015F', 'description': 'Results Reviewed & Doc'},
            {
              'code': 'Excl: Q51.5, Z90.710, Z90.712',
              'description': 'Hysterectomy and or absence of Cervix'
            },
            {'code': 'Q0091', 'description': 'Screening Papanicolaou Smear'},
          ]
        },
      ]
    },
    {
      'title': 'PEDIATRIC QUALITY CODES',
      'sections': [
        {
          'title': 'ESTABLISHED PATIENTS\' PROCEDURE CODES: 99391',
          'items': [
            {'code': '99391', 'description': 'Younger than 1 year'},
            {'code': '99392', 'description': 'Age 1-4 years'},
            {'code': '99393', 'description': '5-11 Years'},
            {'code': '99394', 'description': '12-17 years'},
            {'code': '99395', 'description': '18 years or older'},
          ]
        },
        {
          'title': 'IMMUNIZATIONS & VACCINES',
          'items': [
            {'code': 'Z23', 'description': 'Encounter for immunization.'},
            {
              'code': '90460',
              'description':
                  'Immunization administration through 18 years of age via any route of administration, with counseling by physician or other qualified health care professional; first or only component of each vaccine or toxoid administered.'
            },
            {
              'code': '90471',
              'description':
                  'Immunization administration for percutaneous, intradermal, subcutaneous, or intramuscular injections, initial.'
            },
            {
              'code': '90472',
              'description':
                  'Immunization administration (includes percutaneous, intradermal, subcutaneous, or intramuscular injections), each additional vaccine (single or combination vaccine/toxoid).'
            },
            {'code': '90700, 90715, 90714, 90718', 'description': 'DTaP/Tdap'},
            {'code': '90723', 'description': 'DTaP-HepB-IPV'},
            {'code': '90698', 'description': 'DTaP-IPV/Hib'},
            {'code': '90698, 90713, 90723', 'description': 'IPV (polio)'},
            {'code': '90633', 'description': 'Hep A'},
            {'code': '90723, 90740, 90744, 90747', 'description': 'Hep B'},
            {'code': '90651, 90649, 90650', 'description': 'HPV'},
            {'code': '90644, 90647, 90648', 'description': 'HIB'},
            {'code': '90734, 90733', 'description': 'Meningococcal'},
            {'code': '90707, 90710', 'description': 'MMR'},
            {'code': '90670, 90732', 'description': 'Pneumococcal'},
            {'code': '90710, 90716', 'description': 'Varicella'},
            {
              'code': '90680 (1 dose), 90681 (2 dose)',
              'description': 'Rotavirus'
            },
            {
              'code':
                  '90656, 90685, 90686, 90687, 90688, 90674, 90756, 90682, 90672, 90630, 90655, 90656, 90657',
              'description': 'Influenza'
            },
          ]
        },
      ]
    },
    {
      'title': 'POSTPARTUM CARE VISIT',
      'sections': [
        {
          'title': 'Document Results',
          'items': [
            {'code': '0500F', 'description': 'Postpartum Care Visit'},
            {
              'code':
                  'Z00.XX, Z39.2, Z01.411, Z01.419, Z01.42, Z30.430, Z39.1, Z39.2',
              'description': 'Initial prenatal care visit'
            },
          ]
        },
      ]
    },
    {
      'title': 'PRENATAL CARE VISIT',
      'sections': [
        {
          'title': 'Document Results',
          'items': [
            {'code': '992XX', 'description': 'Prenatal Care Visit'},
            {'code': '0500F', 'description': 'Initial Prenatal Care Visit'},
            {'code': '0502F', 'description': 'Subsequent Prenatal Care Visit'},
          ]
        },
      ]
    },
    {
      'title': 'QUALITY CODES',
      'sections': [
        {
          'title': 'CONTROLLING HIGH BLOOD PRESSURE: Z01.31, Z01.30',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {'code': '3074F', 'description': '<130'},
                {'code': '3075F', 'description': '130-139'},
                {'code': '3077F', 'description': '>140'},
                {'code': '3078F', 'description': '<80'},
                {'code': '3079F', 'description': '80-89'},
                {'code': '3080F', 'description': '>90'},
              ]
            },
          ]
        },
      ]
    },
    {
      'title': 'TRANSITIONAL CARE',
      'sections': [
        {
          'title': 'Document Results',
          'items': [
            {
              'code': '99495',
              'description': 'Transitional Care 14 days after discharge'
            },
            {
              'code': '99496',
              'description': 'Transitional Care 7 days after discharge'
            },
            {
              'code': '1111F',
              'description': 'Medication Reconciliation post discharge'
            },
          ]
        },
      ]
    },
  ];

  // Risk Adjustments items data
  final List<Map<String, dynamic>> _riskItems = [
    {
      'title': 'AMPUTATION DISEASE GROUP',
      'sections': [
        {
          'title':
              'HCC409 - Amputation Status, Lower Limb/Amputation Complications',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'G546',
                  'description': 'Phantom limb syndrome without pain'
                },
                {
                  'code': 'G547',
                  'description': 'Phantom limb syndrome with pain'
                },
                {
                  'code': 'Z89431',
                  'description': 'Acquired absence of right foot'
                },
                {
                  'code': 'Z89432',
                  'description': 'Acquired absence of left foot'
                },
                {
                  'code': 'Z89439',
                  'description': 'Acquired absence of unspecified foot'
                },
                {
                  'code': 'Z89441',
                  'description': 'Acquired absence of right ankle'
                },
                {
                  'code': 'Z89442',
                  'description': 'Acquired absence of left ankle'
                },
                {
                  'code': 'Z89449',
                  'description': 'Acquired absence of unspecified ankle'
                },
                {
                  'code': 'Z89511',
                  'description': 'Acquired absence of right leg below knee'
                },
                {
                  'code': 'Z89512',
                  'description': 'Acquired absence of left leg below knee'
                },
                {
                  'code': 'Z89519',
                  'description':
                      'Acquired absence of unspecified leg below knee'
                },
                {
                  'code': 'Z89611',
                  'description': 'Acquired absence of right leg above knee'
                },
                {
                  'code': 'Z89612',
                  'description': 'Acquired absence of left leg above knee'
                },
                {
                  'code': 'Z89619',
                  'description':
                      'Acquired absence of unspecified leg above knee'
                },
                {
                  'code': 'Z9713',
                  'description': 'Presence of artificial right leg'
                },
                {
                  'code': 'Z9714',
                  'description': 'Presence of artificial left leg'
                },
                {
                  'code': 'Z9716',
                  'description': 'Presence of artificial leg, unspecified'
                },
              ]
            },
          ]
        },
      ]
    },
    {
      'title': 'BLOOD DISEASE GROUP',
      'sections': [
        {
          'title':
              'HCC107 - Sickle Cell Anemia (Hb-SS) and Thalassemia Beta Zero',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'D5700',
                  'description': 'Hb-SS disease with crisis, unspecified'
                },
                {
                  'code': 'D5701',
                  'description': 'Hb-SS disease with acute chest syndrome'
                },
                {
                  'code': 'D5702',
                  'description': 'Hb-SS disease with splenic sequestration'
                },
                {
                  'code': 'D5703',
                  'description':
                      'Hb-SS disease with cerebral vascular involvement'
                },
                {
                  'code': 'D5704',
                  'description': 'Hb-SS disease with dactylitis'
                },
                {
                  'code': 'D5709',
                  'description':
                      'Hb-SS disease with crisis with other specified complication'
                },
                {
                  'code': 'D571',
                  'description': 'Sickle-cell disease without crisis'
                },
                {
                  'code': 'D5742',
                  'description':
                      'Sickle-cell thalassemia beta zero without crisis'
                },
                {
                  'code': 'D57431',
                  'description':
                      'Sickle-cell thalassemia beta zero with acute chest syndrome'
                },
                {
                  'code': 'D57432',
                  'description':
                      'Sickle-cell thalassemia beta zero with splenic sequestration'
                },
                {
                  'code': 'D57433',
                  'description':
                      'Sickle-cell thalassemia beta zero with cerebral vascular involvement'
                },
                {
                  'code': 'D57434',
                  'description':
                      'Sickle-cell thalassemia beta zero with dactylitis'
                },
                {
                  'code': 'D57438',
                  'description':
                      'Sickle-cell thalassemia beta zero with crisis with other specified complication'
                },
                {
                  'code': 'D57439',
                  'description':
                      'Sickle-cell thalassemia beta zero with crisis, unspecified'
                },
              ]
            },
          ]
        },
        {
          'title':
              'HCC108 - Sickle Cell Disorders, Except Sickle Cell Anemia (Hb-SS) and Thalassemia Beta Zero; Beta Thalassemia Major',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {'code': 'D561', 'description': 'Beta thalassemia'},
                {'code': 'D562', 'description': 'Delta-beta thalassemia'},
                {
                  'code': 'D565',
                  'description': 'Hemoglobin E-beta thalassemia'
                },
                {
                  'code': 'D5720',
                  'description': 'Sickle-cell/Hb-C disease without crisis'
                },
                {
                  'code': 'D57211',
                  'description':
                      'Sickle-cell/Hb-C disease with acute chest syndrome'
                },
                {
                  'code': 'D57212',
                  'description':
                      'Sickle-cell/Hb-C disease with splenic sequestration'
                },
                {
                  'code': 'D57213',
                  'description':
                      'Sickle-cell/Hb-C disease with cerebral vascular involvement'
                },
                {
                  'code': 'D57214',
                  'description': 'Sickle-cell/Hb-C disease with dactylitis'
                },
                {
                  'code': 'D57218',
                  'description':
                      'Sickle-cell/Hb-C disease with crisis with other specified complication'
                },
                {
                  'code': 'D57219',
                  'description':
                      'Sickle-cell/Hb-C disease with crisis, unspecified'
                },
                {
                  'code': 'D5740',
                  'description': 'Sickle-cell thalassemia without crisis'
                },
                {
                  'code': 'D57411',
                  'description':
                      'Sickle-cell thalassemia, unspecified, with acute chest syndrome'
                },
                {
                  'code': 'D57412',
                  'description':
                      'Sickle-cell thalassemia, unspecified, with splenic sequestration'
                },
                {
                  'code': 'D57413',
                  'description':
                      'Sickle-cell thalassemia, unspecified, with cerebral vascular involvement'
                },
                {
                  'code': 'D57414',
                  'description':
                      'Sickle-cell thalassemia, unspecified, with dactylitis'
                },
                {
                  'code': 'D57418',
                  'description':
                      'Sickle-cell thalassemia, unspecified, with crisis with other specified complication'
                },
                {
                  'code': 'D57419',
                  'description':
                      'Sickle-cell thalassemia, unspecified, with crisis'
                },
                {
                  'code': 'D5744',
                  'description':
                      'Sickle-cell thalassemia beta plus without crisis'
                },
                {
                  'code': 'D57451',
                  'description':
                      'Sickle-cell thalassemia beta plus with acute chest syndrome'
                },
                {
                  'code': 'D57452',
                  'description':
                      'Sickle-cell thalassemia beta plus with splenic sequestration'
                },
                {
                  'code': 'D57453',
                  'description':
                      'Sickle-cell thalassemia beta plus with cerebral vascular involvement'
                },
                {
                  'code': 'D57454',
                  'description':
                      'Sickle-cell thalassemia beta plus with dactylitis'
                },
                {
                  'code': 'D57458',
                  'description':
                      'Sickle-cell thalassemia beta plus with crisis with other specified complication'
                },
                {
                  'code': 'D57459',
                  'description':
                      'Sickle-cell thalassemia beta plus with crisis, unspecified'
                },
                {
                  'code': 'D5780',
                  'description': 'Other sickle-cell disorders without crisis'
                },
                {
                  'code': 'D57811',
                  'description':
                      'Other sickle-cell disorders with acute chest syndrome'
                },
                {
                  'code': 'D57812',
                  'description':
                      'Other sickle-cell disorders with splenic sequestration'
                },
                {
                  'code': 'D57813',
                  'description':
                      'Other sickle-cell disorders with cerebral vascular involvement'
                },
                {
                  'code': 'D57814',
                  'description': 'Other sickle-cell disorders with dactylitis'
                },
                {
                  'code': 'D57818',
                  'description':
                      'Other sickle-cell disorders with crisis with other specified complication'
                },
                {
                  'code': 'D57819',
                  'description':
                      'Other sickle-cell disorders with crisis, unspecified'
                },
              ]
            },
          ]
        },
        {
          'title':
              'HCC109 - Acquired Hemolytic, Aplastic, and Sideroblastic Anemias',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'D590',
                  'description': 'Drug-induced autoimmune hemolytic anemia'
                },
                {
                  'code': 'D591',
                  'description': 'Other autoimmune hemolytic anemias'
                },
                {
                  'code': 'D592',
                  'description': 'Drug-induced nonautoimmune hemolytic anemia'
                },
                {'code': 'D593', 'description': 'Hemolytic-uremic syndrome'},
                {
                  'code': 'D594',
                  'description': 'Other nonautoimmune hemolytic anemias'
                },
                {
                  'code': 'D595',
                  'description':
                      'Paroxysmal nocturnal hemoglobinuria [Marchiafava-Micheli]'
                },
                {
                  'code': 'D596',
                  'description':
                      'Hemoglobinuria due to hemolysis from other external causes'
                },
                {
                  'code': 'D598',
                  'description': 'Other acquired hemolytic anemias'
                },
                {
                  'code': 'D599',
                  'description': 'Acquired hemolytic anemia, unspecified'
                },
                {
                  'code': 'D600',
                  'description': 'Chronic acquired pure red cell aplasia'
                },
                {
                  'code': 'D601',
                  'description': 'Transient acquired pure red cell aplasia'
                },
                {
                  'code': 'D608',
                  'description': 'Other acquired pure red cell aplasias'
                },
                {
                  'code': 'D609',
                  'description': 'Acquired pure red cell aplasia, unspecified'
                },
                {
                  'code': 'D6101',
                  'description':
                      'Antineoplastic chemotherapy induced pancytopenia'
                },
                {
                  'code': 'D6109',
                  'description': 'Other drug-induced pancytopenia'
                },
                {
                  'code': 'D611',
                  'description':
                      'Aplastic anemia due to antineoplastic chemotherapy'
                },
                {
                  'code': 'D612',
                  'description':
                      'Aplastic anemia due to other drugs and external agents'
                },
                {'code': 'D613', 'description': 'Idiopathic aplastic anemia'},
                {
                  'code': 'D6181',
                  'description':
                      'Other specified aplastic anemias and other bone marrow failure syndromes'
                },
                {'code': 'D6189', 'description': 'Other pancytopenias'},
                {'code': 'D619', 'description': 'Aplastic anemia, unspecified'},
                {
                  'code': 'D640',
                  'description': 'Hereditary sideroblastic anemia'
                },
                {
                  'code': 'D641',
                  'description': 'Secondary sideroblastic anemia due to disease'
                },
                {
                  'code': 'D642',
                  'description':
                      'Secondary sideroblastic anemia due to drugs and toxins'
                },
                {'code': 'D643', 'description': 'Other sideroblastic anemias'},
                {'code': 'D644', 'description': 'Other specified anemias'},
                {
                  'code': 'D6481',
                  'description': 'Anemia due to antineoplastic chemotherapy'
                },
                {'code': 'D6489', 'description': 'Other specified anemias'},
              ]
            },
          ]
        },
        {
          'title': 'HCC111 - Hemophilia, Male',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'D66',
                  'description': 'Hereditary factor VIII deficiency'
                },
                {
                  'code': 'D67',
                  'description': 'Hereditary factor IX deficiency'
                },
                {'code': 'D680', 'description': 'Von Willebrand disease'},
                {
                  'code': 'D681',
                  'description': 'Hereditary factor XI deficiency'
                },
                {
                  'code': 'D682',
                  'description':
                      'Hereditary deficiency of other clotting factors'
                },
                {'code': 'D6831', 'description': 'Acquired hemophilia'},
                {
                  'code': 'D6832',
                  'description': 'Acquired deficiency of other clotting factors'
                },
                {
                  'code': 'D684',
                  'description': 'Acquired coagulation factor deficiency'
                },
                {
                  'code': 'D688',
                  'description': 'Other specified coagulation defects'
                },
                {
                  'code': 'D689',
                  'description': 'Coagulation defect, unspecified'
                },
              ]
            },
          ]
        },
        {
          'title':
              'HCC112 - Immune Thrombocytopenia and Specified Coagulation Defects and Hemorrhagic Conditions',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {'code': 'D690', 'description': 'Allergic purpura'},
                {'code': 'D691', 'description': 'Qualitative platelet defects'},
                {
                  'code': 'D692',
                  'description': 'Other nonthrombocytopenic purpura'
                },
                {
                  'code': 'D693',
                  'description': 'Immune thrombocytopenic purpura'
                },
                {'code': 'D6941', 'description': 'Evans syndrome'},
                {
                  'code': 'D6942',
                  'description':
                      'Congenital and hereditary thrombocytopenic purpura'
                },
                {
                  'code': 'D6949',
                  'description': 'Other primary thrombocytopenia'
                },
                {'code': 'D695', 'description': 'Secondary thrombocytopenia'},
                {
                  'code': 'D696',
                  'description': 'Thrombocytopenia, unspecified'
                },
                {
                  'code': 'D698',
                  'description': 'Other specified hemorrhagic conditions'
                },
                {
                  'code': 'D699',
                  'description': 'Hemorrhagic condition, unspecified'
                },
              ]
            },
          ]
        },
        {
          'title': 'HCC114 - Common Variable and Combined Immunodeficiencies',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'D810',
                  'description':
                      'Severe combined immunodeficiency [SCID] with reticular dysgenesis'
                },
                {
                  'code': 'D811',
                  'description':
                      'Severe combined immunodeficiency [SCID] with low T- and B-cell numbers'
                },
                {
                  'code': 'D812',
                  'description':
                      'Severe combined immunodeficiency [SCID] with low or normal B-cell numbers'
                },
                {
                  'code': 'D813',
                  'description':
                      'Severe combined immunodeficiency [SCID] with low or normal T-cell numbers'
                },
                {'code': 'D814', 'description': 'Nezelof syndrome'},
                {
                  'code': 'D815',
                  'description': 'Purine nucleoside phosphorylase deficiency'
                },
                {
                  'code': 'D816',
                  'description':
                      'Major histocompatibility complex class I deficiency'
                },
                {
                  'code': 'D817',
                  'description':
                      'Major histocompatibility complex class II deficiency'
                },
                {
                  'code': 'D818',
                  'description': 'Other combined immunodeficiencies'
                },
                {
                  'code': 'D819',
                  'description': 'Combined immunodeficiency, unspecified'
                },
                {'code': 'D820', 'description': 'Wiskott-Aldrich syndrome'},
                {'code': 'D821', 'description': 'DiGeorge syndrome'},
                {
                  'code': 'D822',
                  'description': 'Immunodeficiency with short-limbed stature'
                },
                {
                  'code': 'D823',
                  'description':
                      'Immunodeficiency following hereditary defective response to Epstein-Barr virus'
                },
                {
                  'code': 'D824',
                  'description': 'Hyperimmunoglobulin E [IgE] syndrome'
                },
                {
                  'code': 'D828',
                  'description':
                      'Immunodeficiency associated with other major defects'
                },
                {
                  'code': 'D829',
                  'description':
                      'Immunodeficiency associated with other major defects, unspecified'
                },
                {
                  'code': 'D830',
                  'description':
                      'Common variable immunodeficiency with predominant abnormalities of B-cell numbers and function'
                },
                {
                  'code': 'D831',
                  'description':
                      'Common variable immunodeficiency with predominant immunoregulatory T-cell disorders'
                },
                {
                  'code': 'D832',
                  'description':
                      'Common variable immunodeficiency with autoantibodies to B- or T-cells'
                },
                {
                  'code': 'D838',
                  'description': 'Other common variable immunodeficiencies'
                },
                {
                  'code': 'D839',
                  'description': 'Common variable immunodeficiency, unspecified'
                },
              ]
            },
          ]
        },
        {
          'title':
              'HCC115 - Specified Immunodeficiencies and White Blood Cell Disorders',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'D840',
                  'description': 'Lymphocyte function antigen-1 [LFA-1] defect'
                },
                {
                  'code': 'D841',
                  'description': 'Defects in the complement system'
                },
                {
                  'code': 'D842',
                  'description': 'Defects in the complement system, unspecified'
                },
                {
                  'code': 'D843',
                  'description': 'Defects in the complement system, unspecified'
                },
                {
                  'code': 'D844',
                  'description': 'Defects in the complement system, unspecified'
                },
                {'code': 'D848', 'description': 'Other immunodeficiencies'},
                {
                  'code': 'D849',
                  'description': 'Immunodeficiency, unspecified'
                },
                {'code': 'D860', 'description': 'Pulmonary sarcoidosis'},
                {'code': 'D861', 'description': 'Lymph node sarcoidosis'},
                {
                  'code': 'D862',
                  'description': 'Sarcoidosis of other and combined sites'
                },
                {'code': 'D863', 'description': 'Sarcoidosis, unspecified'},
                {'code': 'D868', 'description': 'Sarcoidosis of other sites'},
                {'code': 'D869', 'description': 'Sarcoidosis, unspecified'},
                {
                  'code': 'D890',
                  'description': 'Polyclonal hypergammaglobulinemia'
                },
                {'code': 'D891', 'description': 'Cryoglobulinemia'},
                {
                  'code': 'D892',
                  'description': 'Hypergammaglobulinemia, unspecified'
                },
                {
                  'code': 'D893',
                  'description': 'Immunoproliferative small intestinal disease'
                },
                {'code': 'D894', 'description': 'Castleman disease'},
                {
                  'code': 'D898',
                  'description':
                      'Other specified disorders involving the immune mechanism, not elsewhere classified'
                },
                {
                  'code': 'D899',
                  'description':
                      'Disorder involving the immune mechanism, unspecified'
                },
              ]
            },
          ]
        },
        {
          'title': 'HCC46 - Severe Hematological Disorders',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'D46.0',
                  'description':
                      'Refractory anemia without ring sideroblasts, so stated'
                },
                {
                  'code': 'D46.1',
                  'description': 'Refractory anemia with ring sideroblasts'
                },
                {
                  'code': 'D46.2',
                  'description': 'Refractory anemia with excess of blasts'
                },
                {
                  'code': 'D46.3',
                  'description':
                      'Refractory anemia with excess of blasts with transformation'
                },
                {
                  'code': 'D46.4',
                  'description': 'Refractory anemia, unspecified'
                },
                {
                  'code': 'D46.5',
                  'description':
                      'Refractory cytopenia with multilineage dysplasia'
                },
                {
                  'code': 'D46.6',
                  'description':
                      'Refractory cytopenia with multilineage dysplasia and ring sideroblasts'
                },
                {
                  'code': 'D46.7',
                  'description':
                      'Refractory cytopenia with multilineage dysplasia, unspecified'
                },
                {
                  'code': 'D46.9',
                  'description': 'Myelodysplastic syndrome, unspecified'
                },
                {
                  'code': 'D47.0',
                  'description':
                      'Histiocytic and mast cell tumors of uncertain and unknown behavior'
                },
                {
                  'code': 'D47.1',
                  'description': 'Chronic myeloproliferative disease'
                },
                {'code': 'D47.2', 'description': 'Monoclonal gammopathy'},
                {
                  'code': 'D47.3',
                  'description': 'Essential (hemorrhagic) thrombocythemia'
                },
                {'code': 'D47.4', 'description': 'Osteomyelofibrosis'},
                {
                  'code': 'D47.5',
                  'description':
                      'Chronic eosinophilic leukemia [hypereosinophilic syndrome]'
                },
                {
                  'code': 'D47.6',
                  'description':
                      'Other specified neoplasms of uncertain behavior of lymphoid, hematopoietic and related tissue'
                },
                {
                  'code': 'D47.9',
                  'description':
                      'Neoplasm of uncertain behavior of lymphoid, hematopoietic and related tissue, unspecified'
                },
              ]
            },
          ]
        },
        {
          'title': 'HCC47 - Disorders of Immunity',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'D80.0',
                  'description': 'Hereditary hypogammaglobulinemia'
                },
                {
                  'code': 'D80.1',
                  'description': 'Nonfamilial hypogammaglobulinemia'
                },
                {
                  'code': 'D80.2',
                  'description':
                      'Selective deficiency of immunoglobulin A [IgA]'
                },
                {
                  'code': 'D80.3',
                  'description':
                      'Selective deficiency of immunoglobulin G [IgG] subclasses'
                },
                {
                  'code': 'D80.4',
                  'description':
                      'Selective deficiency of immunoglobulin M [IgM]'
                },
                {
                  'code': 'D80.5',
                  'description':
                      'Immunodeficiency with increased immunoglobulin M [IgM]'
                },
                {
                  'code': 'D80.6',
                  'description':
                      'Antibody deficiency with near-normal immunoglobulins or with hyperimmunoglobulinemia'
                },
                {
                  'code': 'D80.7',
                  'description': 'Transient hypogammaglobulinemia of infancy'
                },
                {
                  'code': 'D80.8',
                  'description':
                      'Other immunodeficiencies with predominantly antibody defects'
                },
                {
                  'code': 'D80.9',
                  'description':
                      'Immunodeficiency with predominantly antibody defects, unspecified'
                },
                {
                  'code': 'D81.0',
                  'description':
                      'Severe combined immunodeficiency [SCID] with reticular dysgenesis'
                },
                {
                  'code': 'D81.1',
                  'description':
                      'Severe combined immunodeficiency [SCID] with low T- and B-cell numbers'
                },
                {
                  'code': 'D81.2',
                  'description':
                      'Severe combined immunodeficiency [SCID] with low or normal B-cell numbers'
                },
                {
                  'code': 'D81.3',
                  'description':
                      'Severe combined immunodeficiency [SCID] with low or normal T-cell numbers'
                },
                {'code': 'D81.4', 'description': 'Nezelof syndrome'},
                {
                  'code': 'D81.5',
                  'description': 'Purine nucleoside phosphorylase deficiency'
                },
                {
                  'code': 'D81.6',
                  'description':
                      'Major histocompatibility complex class I deficiency'
                },
                {
                  'code': 'D81.7',
                  'description':
                      'Major histocompatibility complex class II deficiency'
                },
                {
                  'code': 'D81.8',
                  'description': 'Other combined immunodeficiencies'
                },
                {
                  'code': 'D81.9',
                  'description': 'Combined immunodeficiency, unspecified'
                },
                {'code': 'D82.0', 'description': 'Wiskott-Aldrich syndrome'},
                {'code': 'D82.1', 'description': 'DiGeorge syndrome'},
                {
                  'code': 'D82.2',
                  'description': 'Immunodeficiency with short-limbed stature'
                },
                {
                  'code': 'D82.3',
                  'description':
                      'Immunodeficiency following hereditary defective response to Epstein-Barr virus'
                },
                {
                  'code': 'D82.4',
                  'description': 'Hyperimmunoglobulin E [IgE] syndrome'
                },
                {
                  'code': 'D82.8',
                  'description':
                      'Immunodeficiency associated with other major defects'
                },
                {
                  'code': 'D82.9',
                  'description':
                      'Immunodeficiency associated with other major defects, unspecified'
                },
                {
                  'code': 'D83.0',
                  'description':
                      'Common variable immunodeficiency with predominant abnormalities of B-cell numbers and function'
                },
                {
                  'code': 'D83.1',
                  'description':
                      'Common variable immunodeficiency with predominant immunoregulatory T-cell disorders'
                },
                {
                  'code': 'D83.2',
                  'description':
                      'Common variable immunodeficiency with autoantibodies to B- or T-cells'
                },
                {
                  'code': 'D83.8',
                  'description': 'Other common variable immunodeficiencies'
                },
                {
                  'code': 'D83.9',
                  'description': 'Common variable immunodeficiency, unspecified'
                },
                {
                  'code': 'D84.0',
                  'description': 'Lymphocyte function antigen-1 [LFA-1] defect'
                },
                {
                  'code': 'D84.1',
                  'description': 'Defects in the complement system'
                },
                {
                  'code': 'D84.2',
                  'description': 'Defects in the complement system, unspecified'
                },
                {
                  'code': 'D84.3',
                  'description': 'Defects in the complement system, unspecified'
                },
                {
                  'code': 'D84.4',
                  'description': 'Defects in the complement system, unspecified'
                },
                {'code': 'D84.8', 'description': 'Other immunodeficiencies'},
                {
                  'code': 'D84.9',
                  'description': 'Immunodeficiency, unspecified'
                },
                {'code': 'D86.0', 'description': 'Pulmonary sarcoidosis'},
                {'code': 'D86.1', 'description': 'Lymph node sarcoidosis'},
                {
                  'code': 'D86.2',
                  'description': 'Sarcoidosis of other and combined sites'
                },
                {'code': 'D86.3', 'description': 'Sarcoidosis, unspecified'},
                {'code': 'D86.8', 'description': 'Sarcoidosis of other sites'},
                {'code': 'D86.9', 'description': 'Sarcoidosis, unspecified'},
                {
                  'code': 'D89.0',
                  'description': 'Polyclonal hypergammaglobulinemia'
                },
                {'code': 'D89.1', 'description': 'Cryoglobulinemia'},
                {
                  'code': 'D89.2',
                  'description': 'Hypergammaglobulinemia, unspecified'
                },
                {
                  'code': 'D89.3',
                  'description': 'Immunoproliferative small intestinal disease'
                },
                {'code': 'D89.4', 'description': 'Castleman disease'},
                {
                  'code': 'D89.8',
                  'description':
                      'Other specified disorders involving the immune mechanism, not elsewhere classified'
                },
                {
                  'code': 'D89.9',
                  'description':
                      'Disorder involving the immune mechanism, unspecified'
                },
              ]
            },
          ]
        },
        {
          'title':
              'HCC48 - Coagulation Defects and Other Specified Hematological Disorders',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'D65',
                  'description':
                      'Disseminated intravascular coagulation [defibrination syndrome]'
                },
                {
                  'code': 'D66',
                  'description': 'Hereditary factor VIII deficiency'
                },
                {
                  'code': 'D67',
                  'description': 'Hereditary factor IX deficiency'
                },
                {'code': 'D680', 'description': 'Von Willebrand disease'},
                {
                  'code': 'D681',
                  'description': 'Hereditary factor XI deficiency'
                },
                {
                  'code': 'D682',
                  'description':
                      'Hereditary deficiency of other clotting factors'
                },
                {
                  'code': 'D683',
                  'description':
                      'Hemorrhagic disorder due to circulating anticoagulants'
                },
                {
                  'code': 'D684',
                  'description': 'Acquired coagulation factor deficiency'
                },
                {'code': 'D685', 'description': 'Primary thrombophilia'},
                {'code': 'D686', 'description': 'Other thrombophilia'},
                {
                  'code': 'D688',
                  'description': 'Other specified coagulation defects'
                },
                {
                  'code': 'D689',
                  'description': 'Coagulation defect, unspecified'
                },
                {'code': 'D690', 'description': 'Allergic purpura'},
                {'code': 'D691', 'description': 'Qualitative platelet defects'},
                {
                  'code': 'D692',
                  'description': 'Other nonthrombocytopenic purpura'
                },
                {
                  'code': 'D693',
                  'description': 'Immune thrombocytopenic purpura'
                },
                {
                  'code': 'D694',
                  'description': 'Other primary thrombocytopenia'
                },
                {'code': 'D695', 'description': 'Secondary thrombocytopenia'},
                {
                  'code': 'D696',
                  'description': 'Thrombocytopenia, unspecified'
                },
                {
                  'code': 'D698',
                  'description': 'Other specified hemorrhagic conditions'
                },
                {
                  'code': 'D699',
                  'description': 'Hemorrhagic condition, unspecified'
                },
              ]
            },
          ]
        },
        {
          'title': 'RXHCC21 - Lymphomas and Other Hematologic Cancers',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'C81.00',
                  'description':
                      'Hodgkin lymphoma, unspecified, unspecified site'
                },
                {
                  'code': 'C81.01',
                  'description':
                      'Hodgkin lymphoma, unspecified, lymph nodes of head, face, and neck'
                },
                {
                  'code': 'C81.02',
                  'description':
                      'Hodgkin lymphoma, unspecified, intrathoracic lymph nodes'
                },
                {
                  'code': 'C81.03',
                  'description':
                      'Hodgkin lymphoma, unspecified, intra-abdominal lymph nodes'
                },
                {
                  'code': 'C81.04',
                  'description':
                      'Hodgkin lymphoma, unspecified, lymph nodes of axilla and upper limb'
                },
                {
                  'code': 'C81.05',
                  'description':
                      'Hodgkin lymphoma, unspecified, lymph nodes of inguinal region and lower limb'
                },
                {
                  'code': 'C81.06',
                  'description':
                      'Hodgkin lymphoma, unspecified, intrapelvic lymph nodes'
                },
                {
                  'code': 'C81.07',
                  'description': 'Hodgkin lymphoma, unspecified, spleen'
                },
                {
                  'code': 'C81.08',
                  'description':
                      'Hodgkin lymphoma, unspecified, lymph nodes of multiple sites'
                },
                {
                  'code': 'C81.09',
                  'description':
                      'Hodgkin lymphoma, unspecified, extranodal and solid organ sites'
                },
                {
                  'code': 'C81.10',
                  'description':
                      'Hodgkin lymphoma, nodular sclerosis, unspecified site'
                },
                {
                  'code': 'C81.11',
                  'description':
                      'Hodgkin lymphoma, nodular sclerosis, lymph nodes of head, face, and neck'
                },
                {
                  'code': 'C81.12',
                  'description':
                      'Hodgkin lymphoma, nodular sclerosis, intrathoracic lymph nodes'
                },
                {
                  'code': 'C81.13',
                  'description':
                      'Hodgkin lymphoma, nodular sclerosis, intra-abdominal lymph nodes'
                },
                {
                  'code': 'C81.14',
                  'description':
                      'Hodgkin lymphoma, nodular sclerosis, lymph nodes of axilla and upper limb'
                },
                {
                  'code': 'C81.15',
                  'description':
                      'Hodgkin lymphoma, nodular sclerosis, lymph nodes of inguinal region and lower limb'
                },
                {
                  'code': 'C81.16',
                  'description':
                      'Hodgkin lymphoma, nodular sclerosis, intrapelvic lymph nodes'
                },
                {
                  'code': 'C81.17',
                  'description': 'Hodgkin lymphoma, nodular sclerosis, spleen'
                },
                {
                  'code': 'C81.18',
                  'description':
                      'Hodgkin lymphoma, nodular sclerosis, lymph nodes of multiple sites'
                },
                {
                  'code': 'C81.19',
                  'description':
                      'Hodgkin lymphoma, nodular sclerosis, extranodal and solid organ sites'
                },
                {
                  'code': 'C81.20',
                  'description':
                      'Hodgkin lymphoma, mixed cellularity, unspecified site'
                },
                {
                  'code': 'C81.21',
                  'description':
                      'Hodgkin lymphoma, mixed cellularity, lymph nodes of head, face, and neck'
                },
                {
                  'code': 'C81.22',
                  'description':
                      'Hodgkin lymphoma, mixed cellularity, intrathoracic lymph nodes'
                },
                {
                  'code': 'C81.23',
                  'description':
                      'Hodgkin lymphoma, mixed cellularity, intra-abdominal lymph nodes'
                },
                {
                  'code': 'C81.24',
                  'description':
                      'Hodgkin lymphoma, mixed cellularity, lymph nodes of axilla and upper limb'
                },
                {
                  'code': 'C81.25',
                  'description':
                      'Hodgkin lymphoma, mixed cellularity, lymph nodes of inguinal region and lower limb'
                },
                {
                  'code': 'C81.26',
                  'description':
                      'Hodgkin lymphoma, mixed cellularity, intrapelvic lymph nodes'
                },
                {
                  'code': 'C81.27',
                  'description': 'Hodgkin lymphoma, mixed cellularity, spleen'
                },
                {
                  'code': 'C81.28',
                  'description':
                      'Hodgkin lymphoma, mixed cellularity, lymph nodes of multiple sites'
                },
                {
                  'code': 'C81.29',
                  'description':
                      'Hodgkin lymphoma, mixed cellularity, extranodal and solid organ sites'
                },
                {
                  'code': 'C81.30',
                  'description':
                      'Hodgkin lymphoma, lymphocyte depleted, unspecified site'
                },
                {
                  'code': 'C81.31',
                  'description':
                      'Hodgkin lymphoma, lymphocyte depleted, lymph nodes of head, face, and neck'
                },
                {
                  'code': 'C81.32',
                  'description':
                      'Hodgkin lymphoma, lymphocyte depleted, intrathoracic lymph nodes'
                },
                {
                  'code': 'C81.33',
                  'description':
                      'Hodgkin lymphoma, lymphocyte depleted, intra-abdominal lymph nodes'
                },
                {
                  'code': 'C81.34',
                  'description':
                      'Hodgkin lymphoma, lymphocyte depleted, lymph nodes of axilla and upper limb'
                },
                {
                  'code': 'C81.35',
                  'description':
                      'Hodgkin lymphoma, lymphocyte depleted, lymph nodes of inguinal region and lower limb'
                },
                {
                  'code': 'C81.36',
                  'description':
                      'Hodgkin lymphoma, lymphocyte depleted, intrapelvic lymph nodes'
                },
                {
                  'code': 'C81.37',
                  'description': 'Hodgkin lymphoma, lymphocyte depleted, spleen'
                },
                {
                  'code': 'C81.38',
                  'description':
                      'Hodgkin lymphoma, lymphocyte depleted, lymph nodes of multiple sites'
                },
                {
                  'code': 'C81.39',
                  'description':
                      'Hodgkin lymphoma, lymphocyte depleted, extranodal and solid organ sites'
                },
                {
                  'code': 'C81.40',
                  'description':
                      'Hodgkin lymphoma, lymphocyte rich, unspecified site'
                },
                {
                  'code': 'C81.41',
                  'description':
                      'Hodgkin lymphoma, lymphocyte rich, lymph nodes of head, face, and neck'
                },
                {
                  'code': 'C81.42',
                  'description':
                      'Hodgkin lymphoma, lymphocyte rich, intrathoracic lymph nodes'
                },
                {
                  'code': 'C81.43',
                  'description':
                      'Hodgkin lymphoma, lymphocyte rich, intra-abdominal lymph nodes'
                },
                {
                  'code': 'C81.44',
                  'description':
                      'Hodgkin lymphoma, lymphocyte rich, lymph nodes of axilla and upper limb'
                },
                {
                  'code': 'C81.45',
                  'description':
                      'Hodgkin lymphoma, lymphocyte rich, lymph nodes of inguinal region and lower limb'
                },
                {
                  'code': 'C81.46',
                  'description':
                      'Hodgkin lymphoma, lymphocyte rich, intrapelvic lymph nodes'
                },
                {
                  'code': 'C81.47',
                  'description': 'Hodgkin lymphoma, lymphocyte rich, spleen'
                },
                {
                  'code': 'C81.48',
                  'description':
                      'Hodgkin lymphoma, lymphocyte rich, lymph nodes of multiple sites'
                },
                {
                  'code': 'C81.49',
                  'description':
                      'Hodgkin lymphoma, lymphocyte rich, extranodal and solid organ sites'
                },
                {
                  'code': 'C81.70',
                  'description': 'Other Hodgkin lymphoma, unspecified site'
                },
                {
                  'code': 'C81.71',
                  'description':
                      'Other Hodgkin lymphoma, lymph nodes of head, face, and neck'
                },
                {
                  'code': 'C81.72',
                  'description':
                      'Other Hodgkin lymphoma, intrathoracic lymph nodes'
                },
                {
                  'code': 'C81.73',
                  'description':
                      'Other Hodgkin lymphoma, intra-abdominal lymph nodes'
                },
                {
                  'code': 'C81.74',
                  'description':
                      'Other Hodgkin lymphoma, lymph nodes of axilla and upper limb'
                },
                {
                  'code': 'C81.75',
                  'description':
                      'Other Hodgkin lymphoma, lymph nodes of inguinal region and lower limb'
                },
                {
                  'code': 'C81.76',
                  'description':
                      'Other Hodgkin lymphoma, intrapelvic lymph nodes'
                },
                {
                  'code': 'C81.77',
                  'description': 'Other Hodgkin lymphoma, spleen'
                },
                {
                  'code': 'C81.78',
                  'description':
                      'Other Hodgkin lymphoma, lymph nodes of multiple sites'
                },
                {
                  'code': 'C81.79',
                  'description':
                      'Other Hodgkin lymphoma, extranodal and solid organ sites'
                },
                {
                  'code': 'C81.90',
                  'description':
                      'Hodgkin lymphoma, unspecified, unspecified site'
                },
                {
                  'code': 'C81.91',
                  'description':
                      'Hodgkin lymphoma, unspecified, lymph nodes of head, face, and neck'
                },
                {
                  'code': 'C81.92',
                  'description':
                      'Hodgkin lymphoma, unspecified, intrathoracic lymph nodes'
                },
                {
                  'code': 'C81.93',
                  'description':
                      'Hodgkin lymphoma, unspecified, intra-abdominal lymph nodes'
                },
                {
                  'code': 'C81.94',
                  'description':
                      'Hodgkin lymphoma, unspecified, lymph nodes of axilla and upper limb'
                },
                {
                  'code': 'C81.95',
                  'description':
                      'Hodgkin lymphoma, unspecified, lymph nodes of inguinal region and lower limb'
                },
                {
                  'code': 'C81.96',
                  'description':
                      'Hodgkin lymphoma, unspecified, intrapelvic lymph nodes'
                },
                {
                  'code': 'C81.97',
                  'description': 'Hodgkin lymphoma, unspecified, spleen'
                },
                {
                  'code': 'C81.98',
                  'description':
                      'Hodgkin lymphoma, unspecified, lymph nodes of multiple sites'
                },
                {
                  'code': 'C81.99',
                  'description':
                      'Hodgkin lymphoma, unspecified, extranodal and solid organ sites'
                },
              ]
            },
          ]
        },
        {
          'title': 'RXHCC99 - Immune Disorders',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'D890',
                  'description': 'Polyclonal hypergammaglobulinemia'
                },
              ]
            },
          ]
        },
      ]
    },
    {
      'title': 'CEREBROVASCULAR DISEASE GROUP',
      'sections': [
        {
          'title': 'HCC253 - Hemiplegia/Hemiparesis',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'I69051',
                  'description':
                      'Hemiplegia and hemiparesis following nontraumatic subarachnoid hemorrhage affecting right dominant side'
                },
                {
                  'code': 'I69052',
                  'description':
                      'Hemiplegia and hemiparesis following nontraumatic subarachnoid hemorrhage affecting left dominant side'
                },
                {
                  'code': 'I69053',
                  'description':
                      'Hemiplegia and hemiparesis following nontraumatic subarachnoid hemorrhage affecting right non-dominant side'
                },
                {
                  'code': 'I69054',
                  'description':
                      'Hemiplegia and hemiparesis following nontraumatic subarachnoid hemorrhage affecting left non-dominant side'
                },
                {
                  'code': 'I69059',
                  'description':
                      'Hemiplegia and hemiparesis following nontraumatic subarachnoid hemorrhage affecting unspecified side'
                },
                {
                  'code': 'I69151',
                  'description':
                      'Hemiplegia and hemiparesis following nontraumatic intracerebral hemorrhage affecting right dominant side'
                },
                {
                  'code': 'I69152',
                  'description':
                      'Hemiplegia and hemiparesis following nontraumatic intracerebral hemorrhage affecting left dominant side'
                },
                {
                  'code': 'I69153',
                  'description':
                      'Hemiplegia and hemiparesis following nontraumatic intracerebral hemorrhage affecting right non-dominant side'
                },
                {
                  'code': 'I69154',
                  'description':
                      'Hemiplegia and hemiparesis following nontraumatic intracerebral hemorrhage affecting left non-dominant side'
                },
                {
                  'code': 'I69159',
                  'description':
                      'Hemiplegia and hemiparesis following nontraumatic intracerebral hemorrhage affecting unspecified side'
                },
                {
                  'code': 'I69251',
                  'description':
                      'Hemiplegia and hemiparesis following other nontraumatic intracranial hemorrhage affecting right dominant side'
                },
                {
                  'code': 'I69252',
                  'description':
                      'Hemiplegia and hemiparesis following other nontraumatic intracranial hemorrhage affecting left dominant side'
                },
                {
                  'code': 'I69253',
                  'description':
                      'Hemiplegia and hemiparesis following other nontraumatic intracranial hemorrhage affecting right non-dominant side'
                },
                {
                  'code': 'I69254',
                  'description':
                      'Hemiplegia and hemiparesis following other nontraumatic intracranial hemorrhage affecting left non-dominant side'
                },
                {
                  'code': 'I69259',
                  'description':
                      'Hemiplegia and hemiparesis following other nontraumatic intracranial hemorrhage affecting unspecified side'
                },
                {
                  'code': 'I69351',
                  'description':
                      'Hemiplegia and hemiparesis following cerebral infarction affecting right dominant side'
                },
                {
                  'code': 'I69352',
                  'description':
                      'Hemiplegia and hemiparesis following cerebral infarction affecting left dominant side'
                },
                {
                  'code': 'I69353',
                  'description':
                      'Hemiplegia and hemiparesis following cerebral infarction affecting right non-dominant side'
                },
                {
                  'code': 'I69354',
                  'description':
                      'Hemiplegia and hemiparesis following cerebral infarction affecting left non-dominant side'
                },
                {
                  'code': 'I69359',
                  'description':
                      'Hemiplegia and hemiparesis following cerebral infarction affecting unspecified side'
                },
                {
                  'code': 'I69851',
                  'description':
                      'Hemiplegia and hemiparesis following other cerebrovascular disease affecting right dominant side'
                },
                {
                  'code': 'I69852',
                  'description':
                      'Hemiplegia and hemiparesis following other cerebrovascular disease affecting left dominant side'
                },
                {
                  'code': 'I69853',
                  'description':
                      'Hemiplegia and hemiparesis following other cerebrovascular disease affecting right non-dominant side'
                },
                {
                  'code': 'I69854',
                  'description':
                      'Hemiplegia and hemiparesis following other cerebrovascular disease affecting left non-dominant side'
                },
                {
                  'code': 'I69859',
                  'description':
                      'Hemiplegia and hemiparesis following other cerebrovascular disease affecting unspecified side'
                },
                {
                  'code': 'I69951',
                  'description':
                      'Hemiplegia and hemiparesis following unspecified cerebrovascular disease affecting right dominant side'
                },
                {
                  'code': 'I69952',
                  'description':
                      'Hemiplegia and hemiparesis following unspecified cerebrovascular disease affecting left dominant side'
                },
                {
                  'code': 'I69953',
                  'description':
                      'Hemiplegia and hemiparesis following unspecified cerebrovascular disease affecting right non-dominant side'
                },
                {
                  'code': 'I69954',
                  'description':
                      'Hemiplegia and hemiparesis following unspecified cerebrovascular disease affecting left non-dominant side'
                },
                {
                  'code': 'I69959',
                  'description':
                      'Hemiplegia and hemiparesis following unspecified cerebrovascular disease affecting unspecified side'
                },
                {'code': 'G810', 'description': 'Flaccid hemiplegia'},
                {'code': 'G811', 'description': 'Spastic hemiplegia'},
                {'code': 'G819', 'description': 'Hemiplegia, unspecified'},
              ]
            },
          ]
        },
        {
          'title': 'HCC254 - Monoplegia, Other Paralytic Syndromes',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {'code': 'G820', 'description': 'Flaccid paraplegia'},
                {'code': 'G821', 'description': 'Spastic paraplegia'},
                {'code': 'G822', 'description': 'Paraplegia, unspecified'},
                {'code': 'G8230', 'description': 'Quadriplegia, unspecified'},
                {
                  'code': 'G8231',
                  'description': 'Quadriplegia, C1-C4 complete'
                },
                {
                  'code': 'G8232',
                  'description': 'Quadriplegia, C1-C4 incomplete'
                },
                {
                  'code': 'G8233',
                  'description': 'Quadriplegia, C5-C7 complete'
                },
                {
                  'code': 'G8234',
                  'description': 'Quadriplegia, C5-C7 incomplete'
                },
                {'code': 'G8240', 'description': 'Quadriparesis, unspecified'},
                {
                  'code': 'G8241',
                  'description': 'Quadriparesis, C1-C4 complete'
                },
                {
                  'code': 'G8242',
                  'description': 'Quadriparesis, C1-C4 incomplete'
                },
                {
                  'code': 'G8243',
                  'description': 'Quadriparesis, C5-C7 complete'
                },
                {
                  'code': 'G8244',
                  'description': 'Quadriparesis, C5-C7 incomplete'
                },
                {'code': 'G8250', 'description': 'Diplegia of upper limbs'},
                {'code': 'G8251', 'description': 'Diplegia of lower limbs'},
                {
                  'code': 'G8252',
                  'description': 'Diplegia of upper and lower limbs'
                },
                {
                  'code': 'G8253',
                  'description': 'Diplegia of one side of body'
                },
                {
                  'code': 'G8254',
                  'description': 'Diplegia of other specified sites'
                },
                {'code': 'G8259', 'description': 'Diplegia, unspecified'},
                {'code': 'G830', 'description': 'Diplegia of upper limbs'},
                {
                  'code': 'G8310',
                  'description': 'Monoplegia of upper limb, unspecified'
                },
                {
                  'code': 'G8311',
                  'description':
                      'Monoplegia of upper limb affecting right dominant side'
                },
                {
                  'code': 'G8312',
                  'description':
                      'Monoplegia of upper limb affecting left dominant side'
                },
                {
                  'code': 'G8313',
                  'description':
                      'Monoplegia of upper limb affecting right non-dominant side'
                },
                {
                  'code': 'G8314',
                  'description':
                      'Monoplegia of upper limb affecting left non-dominant side'
                },
                {
                  'code': 'G8320',
                  'description': 'Monoplegia of lower limb, unspecified'
                },
                {
                  'code': 'G8321',
                  'description':
                      'Monoplegia of lower limb affecting right dominant side'
                },
                {
                  'code': 'G8322',
                  'description':
                      'Monoplegia of lower limb affecting left dominant side'
                },
                {
                  'code': 'G8323',
                  'description':
                      'Monoplegia of lower limb affecting right non-dominant side'
                },
                {
                  'code': 'G8324',
                  'description':
                      'Monoplegia of lower limb affecting left non-dominant side'
                },
                {'code': 'G8330', 'description': 'Monoplegia, unspecified'},
                {
                  'code': 'G8331',
                  'description': 'Monoplegia affecting right dominant side'
                },
                {
                  'code': 'G8332',
                  'description': 'Monoplegia affecting left dominant side'
                },
                {
                  'code': 'G8333',
                  'description': 'Monoplegia affecting right non-dominant side'
                },
                {
                  'code': 'G8334',
                  'description': 'Monoplegia affecting left non-dominant side'
                },
                {
                  'code': 'G8340',
                  'description': 'Cauda equina syndrome, unspecified'
                },
                {
                  'code': 'G8341',
                  'description': 'Cauda equina syndrome with neurogenic bladder'
                },
                {
                  'code': 'G8342',
                  'description': 'Cauda equina syndrome with neurogenic bowel'
                },
                {
                  'code': 'G8343',
                  'description':
                      'Cauda equina syndrome with neurogenic bladder and bowel'
                },
                {
                  'code': 'G8349',
                  'description':
                      'Cauda equina syndrome with other specified complications'
                },
                {'code': 'G835', 'description': 'Locked-in state'},
                {
                  'code': 'G838',
                  'description': 'Other specified paralytic syndromes'
                },
                {
                  'code': 'G839',
                  'description': 'Paralytic syndrome, unspecified'
                },
                {
                  'code': 'I69031',
                  'description':
                      'Monoplegia of upper limb following nontraumatic subarachnoid hemorrhage affecting right dominant side'
                },
                {
                  'code': 'I69032',
                  'description':
                      'Monoplegia of upper limb following nontraumatic subarachnoid hemorrhage affecting left dominant side'
                },
                {
                  'code': 'I69033',
                  'description':
                      'Monoplegia of upper limb following nontraumatic subarachnoid hemorrhage affecting right non-dominant side'
                },
                {
                  'code': 'I69034',
                  'description':
                      'Monoplegia of upper limb following nontraumatic subarachnoid hemorrhage affecting left non-dominant side'
                },
                {
                  'code': 'I69039',
                  'description':
                      'Monoplegia of upper limb following nontraumatic subarachnoid hemorrhage affecting unspecified side'
                },
                {
                  'code': 'I69041',
                  'description':
                      'Monoplegia of lower limb following nontraumatic subarachnoid hemorrhage affecting right dominant side'
                },
                {
                  'code': 'I69042',
                  'description':
                      'Monoplegia of lower limb following nontraumatic subarachnoid hemorrhage affecting left dominant side'
                },
                {
                  'code': 'I69043',
                  'description':
                      'Monoplegia of lower limb following nontraumatic subarachnoid hemorrhage affecting right non-dominant side'
                },
                {
                  'code': 'I69044',
                  'description':
                      'Monoplegia of lower limb following nontraumatic subarachnoid hemorrhage affecting left non-dominant side'
                },
                {
                  'code': 'I69049',
                  'description':
                      'Monoplegia of lower limb following nontraumatic subarachnoid hemorrhage affecting unspecified side'
                },
                {
                  'code': 'I69061',
                  'description':
                      'Other paralytic syndrome following nontraumatic subarachnoid hemorrhage affecting right dominant side'
                },
                {
                  'code': 'I69062',
                  'description':
                      'Other paralytic syndrome following nontraumatic subarachnoid hemorrhage affecting left dominant side'
                },
                {
                  'code': 'I69063',
                  'description':
                      'Other paralytic syndrome following nontraumatic subarachnoid hemorrhage affecting right non-dominant side'
                },
                {
                  'code': 'I69064',
                  'description':
                      'Other paralytic syndrome following nontraumatic subarachnoid hemorrhage affecting left non-dominant side'
                },
                {
                  'code': 'I69065',
                  'description':
                      'Other paralytic syndrome following nontraumatic subarachnoid hemorrhage, bilateral'
                },
                {
                  'code': 'I69069',
                  'description':
                      'Other paralytic syndrome following nontraumatic subarachnoid hemorrhage affecting unspecified side'
                },
                {
                  'code': 'I69131',
                  'description':
                      'Monoplegia of upper limb following nontraumatic intracerebral hemorrhage affecting right dominant side'
                },
                {
                  'code': 'I69132',
                  'description':
                      'Monoplegia of upper limb following nontraumatic intracerebral hemorrhage affecting left dominant side'
                },
                {
                  'code': 'I69133',
                  'description':
                      'Monoplegia of upper limb following nontraumatic intracerebral hemorrhage affecting right non-dominant side'
                },
                {
                  'code': 'I69134',
                  'description':
                      'Monoplegia of upper limb following nontraumatic intracerebral hemorrhage affecting left non-dominant side'
                },
                {
                  'code': 'I69139',
                  'description':
                      'Monoplegia of upper limb following nontraumatic intracerebral hemorrhage affecting unspecified side'
                },
                {
                  'code': 'I69141',
                  'description':
                      'Monoplegia of lower limb following nontraumatic intracerebral hemorrhage affecting right dominant side'
                },
                {
                  'code': 'I69142',
                  'description':
                      'Monoplegia of lower limb following nontraumatic intracerebral hemorrhage affecting left dominant side'
                },
                {
                  'code': 'I69143',
                  'description':
                      'Monoplegia of lower limb following nontraumatic intracerebral hemorrhage affecting right non-dominant side'
                },
                {
                  'code': 'I69144',
                  'description':
                      'Monoplegia of lower limb following nontraumatic intracerebral hemorrhage affecting left non-dominant side'
                },
                {
                  'code': 'I69149',
                  'description':
                      'Monoplegia of lower limb following nontraumatic intracerebral hemorrhage affecting unspecified side'
                },
                {
                  'code': 'I69161',
                  'description':
                      'Other paralytic syndrome following nontraumatic intracerebral hemorrhage affecting right dominant side'
                },
                {
                  'code': 'I69162',
                  'description':
                      'Other paralytic syndrome following nontraumatic intracerebral hemorrhage affecting left dominant side'
                },
                {
                  'code': 'I69163',
                  'description':
                      'Other paralytic syndrome following nontraumatic intracerebral hemorrhage affecting right non-dominant side'
                },
                {
                  'code': 'I69164',
                  'description':
                      'Other paralytic syndrome following nontraumatic intracerebral hemorrhage affecting left non-dominant side'
                },
                {
                  'code': 'I69165',
                  'description':
                      'Other paralytic syndrome following nontraumatic intracerebral hemorrhage, bilateral'
                },
                {
                  'code': 'I69169',
                  'description':
                      'Other paralytic syndrome following nontraumatic intracerebral hemorrhage affecting unspecified side'
                },
                {
                  'code': 'I69231',
                  'description':
                      'Monoplegia of upper limb following other nontraumatic intracranial hemorrhage affecting right dominant side'
                },
                {
                  'code': 'I69232',
                  'description':
                      'Monoplegia of upper limb following other nontraumatic intracranial hemorrhage affecting left dominant side'
                },
                {
                  'code': 'I69233',
                  'description':
                      'Monoplegia of upper limb following other nontraumatic intracranial hemorrhage affecting right non-dominant side'
                },
                {
                  'code': 'I69234',
                  'description':
                      'Monoplegia of upper limb following other nontraumatic intracranial hemorrhage affecting left non-dominant side'
                },
                {
                  'code': 'I69239',
                  'description':
                      'Monoplegia of upper limb following other nontraumatic intracranial hemorrhage affecting unspecified side'
                },
                {
                  'code': 'I69241',
                  'description':
                      'Monoplegia of lower limb following other nontraumatic intracranial hemorrhage affecting right dominant side'
                },
                {
                  'code': 'I69242',
                  'description':
                      'Monoplegia of lower limb following other nontraumatic intracranial hemorrhage affecting left dominant side'
                },
                {
                  'code': 'I69243',
                  'description':
                      'Monoplegia of lower limb following other nontraumatic intracranial hemorrhage affecting right non-dominant side'
                },
                {
                  'code': 'I69244',
                  'description':
                      'Monoplegia of lower limb following other nontraumatic intracranial hemorrhage affecting left non-dominant side'
                },
                {
                  'code': 'I69249',
                  'description':
                      'Monoplegia of lower limb following other nontraumatic intracranial hemorrhage affecting unspecified side'
                },
                {
                  'code': 'I69261',
                  'description':
                      'Other paralytic syndrome following other nontraumatic intracranial hemorrhage affecting right dominant side'
                },
                {
                  'code': 'I69262',
                  'description':
                      'Other paralytic syndrome following other nontraumatic intracranial hemorrhage affecting left dominant side'
                },
                {
                  'code': 'I69263',
                  'description':
                      'Other paralytic syndrome following other nontraumatic intracranial hemorrhage affecting right non-dominant side'
                },
                {
                  'code': 'I69264',
                  'description':
                      'Other paralytic syndrome following other nontraumatic intracranial hemorrhage affecting left non-dominant side'
                },
                {
                  'code': 'I69265',
                  'description':
                      'Other paralytic syndrome following other nontraumatic intracranial hemorrhage, bilateral'
                },
                {
                  'code': 'I69269',
                  'description':
                      'Other paralytic syndrome following other nontraumatic intracranial hemorrhage affecting unspecified side'
                },
                {
                  'code': 'I69331',
                  'description':
                      'Monoplegia of upper limb following cerebral infarction affecting right dominant side'
                },
                {
                  'code': 'I69332',
                  'description':
                      'Monoplegia of upper limb following cerebral infarction affecting left dominant side'
                },
                {
                  'code': 'I69333',
                  'description':
                      'Monoplegia of upper limb following cerebral infarction affecting right non-dominant side'
                },
                {
                  'code': 'I69334',
                  'description':
                      'Monoplegia of upper limb following cerebral infarction affecting left non-dominant side'
                },
                {
                  'code': 'I69339',
                  'description':
                      'Monoplegia of upper limb following cerebral infarction affecting unspecified side'
                },
                {
                  'code': 'I69341',
                  'description':
                      'Monoplegia of lower limb following cerebral infarction affecting right dominant side'
                },
                {
                  'code': 'I69342',
                  'description':
                      'Monoplegia of lower limb following cerebral infarction affecting left dominant side'
                },
                {
                  'code': 'I69343',
                  'description':
                      'Monoplegia of lower limb following cerebral infarction affecting right non-dominant side'
                },
                {
                  'code': 'I69344',
                  'description':
                      'Monoplegia of lower limb following cerebral infarction affecting left non-dominant side'
                },
                {
                  'code': 'I69349',
                  'description':
                      'Monoplegia of lower limb following cerebral infarction affecting unspecified side'
                },
                {
                  'code': 'I69361',
                  'description':
                      'Other paralytic syndrome following cerebral infarction affecting right dominant side'
                },
                {
                  'code': 'I69362',
                  'description':
                      'Other paralytic syndrome following cerebral infarction affecting left dominant side'
                },
                {
                  'code': 'I69363',
                  'description':
                      'Other paralytic syndrome following cerebral infarction affecting right non-dominant side'
                },
                {
                  'code': 'I69364',
                  'description':
                      'Other paralytic syndrome following cerebral infarction affecting left non-dominant side'
                },
                {
                  'code': 'I69365',
                  'description':
                      'Other paralytic syndrome following cerebral infarction, bilateral'
                },
                {
                  'code': 'I69369',
                  'description':
                      'Other paralytic syndrome following cerebral infarction affecting unspecified side'
                },
                {
                  'code': 'I69831',
                  'description':
                      'Monoplegia of upper limb following other cerebrovascular disease affecting right dominant side'
                },
                {
                  'code': 'I69832',
                  'description':
                      'Monoplegia of upper limb following other cerebrovascular disease affecting left dominant side'
                },
                {
                  'code': 'I69833',
                  'description':
                      'Monoplegia of upper limb following other cerebrovascular disease affecting right non-dominant side'
                },
                {
                  'code': 'I69834',
                  'description':
                      'Monoplegia of upper limb following other cerebrovascular disease affecting left non-dominant side'
                },
                {
                  'code': 'I69839',
                  'description':
                      'Monoplegia of upper limb following other cerebrovascular disease affecting unspecified side'
                },
                {
                  'code': 'I69841',
                  'description':
                      'Monoplegia of lower limb following other cerebrovascular disease affecting right dominant side'
                },
                {
                  'code': 'I69842',
                  'description':
                      'Monoplegia of lower limb following other cerebrovascular disease affecting left dominant side'
                },
                {
                  'code': 'I69843',
                  'description':
                      'Monoplegia of lower limb following other cerebrovascular disease affecting right non-dominant side'
                },
                {
                  'code': 'I69844',
                  'description':
                      'Monoplegia of lower limb following other cerebrovascular disease affecting left non-dominant side'
                },
                {
                  'code': 'I69849',
                  'description':
                      'Monoplegia of lower limb following other cerebrovascular disease affecting unspecified side'
                },
                {
                  'code': 'I69861',
                  'description':
                      'Other paralytic syndrome following other cerebrovascular disease affecting right dominant side'
                },
                {
                  'code': 'I69862',
                  'description':
                      'Other paralytic syndrome following other cerebrovascular disease affecting left dominant side'
                },
                {
                  'code': 'I69863',
                  'description':
                      'Other paralytic syndrome following other cerebrovascular disease affecting right non-dominant side'
                },
                {
                  'code': 'I69864',
                  'description':
                      'Other paralytic syndrome following other cerebrovascular disease affecting left non-dominant side'
                },
                {
                  'code': 'I69865',
                  'description':
                      'Other paralytic syndrome following other cerebrovascular disease, bilateral'
                },
                {
                  'code': 'I69869',
                  'description':
                      'Other paralytic syndrome following other cerebrovascular disease affecting unspecified side'
                },
                {
                  'code': 'I69931',
                  'description':
                      'Monoplegia of upper limb following unspecified cerebrovascular disease affecting right dominant side'
                },
                {
                  'code': 'I69932',
                  'description':
                      'Monoplegia of upper limb following unspecified cerebrovascular disease affecting left dominant side'
                },
                {
                  'code': 'I69933',
                  'description':
                      'Monoplegia of upper limb following unspecified cerebrovascular disease affecting right non-dominant side'
                },
                {
                  'code': 'I69934',
                  'description':
                      'Monoplegia of upper limb following unspecified cerebrovascular disease affecting left non-dominant side'
                },
                {
                  'code': 'I69939',
                  'description':
                      'Monoplegia of upper limb following unspecified cerebrovascular disease affecting unspecified side'
                },
                {
                  'code': 'I69941',
                  'description':
                      'Monoplegia of lower limb following unspecified cerebrovascular disease affecting right dominant side'
                },
                {
                  'code': 'I69942',
                  'description':
                      'Monoplegia of lower limb following unspecified cerebrovascular disease affecting left dominant side'
                },
                {
                  'code': 'I69943',
                  'description':
                      'Monoplegia of lower limb following unspecified cerebrovascular disease affecting right non-dominant side'
                },
                {
                  'code': 'I69944',
                  'description':
                      'Monoplegia of lower limb following unspecified cerebrovascular disease affecting left non-dominant side'
                },
                {
                  'code': 'I69949',
                  'description':
                      'Monoplegia of lower limb following unspecified cerebrovascular disease affecting unspecified side'
                },
                {
                  'code': 'I69961',
                  'description':
                      'Other paralytic syndrome following unspecified cerebrovascular disease affecting right dominant side'
                },
                {
                  'code': 'I69962',
                  'description':
                      'Other paralytic syndrome following unspecified cerebrovascular disease affecting left dominant side'
                },
                {
                  'code': 'I69963',
                  'description':
                      'Other paralytic syndrome following unspecified cerebrovascular disease affecting right non-dominant side'
                },
                {
                  'code': 'I69964',
                  'description':
                      'Other paralytic syndrome following unspecified cerebrovascular disease affecting left non-dominant side'
                },
                {
                  'code': 'I69965',
                  'description':
                      'Other paralytic syndrome following unspecified cerebrovascular disease, bilateral'
                },
                {
                  'code': 'I69969',
                  'description':
                      'Other paralytic syndrome following unspecified cerebrovascular disease affecting unspecified side'
                },
              ]
            },
          ]
        },
      ]
    },
    {
      'title': 'COGNITIVE DISEASE GROUP',
      'sections': [
        {
          'title': 'HCC125 - Dementia, Severe',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'F01C0',
                  'description':
                      'Vascular dementia, severe, without behavioral disturbance, psychotic disturbance, mood disturbance, and anxiety'
                },
                {
                  'code': 'F01C11',
                  'description': 'Vascular dementia, severe, with agitation'
                },
                {
                  'code': 'F01C18',
                  'description':
                      'Vascular dementia, severe, with other behavioral disturbance'
                },
                {
                  'code': 'F01C2',
                  'description':
                      'Vascular dementia, severe, with psychotic disturbance'
                },
                {
                  'code': 'F01C3',
                  'description':
                      'Vascular dementia, severe, with mood disturbance'
                },
                {
                  'code': 'F01C4',
                  'description': 'Vascular dementia, severe, with anxiety'
                },
                {
                  'code': 'F02C0',
                  'description':
                      'Dementia in other diseases classified elsewhere, severe, without behavioral disturbance, psychotic disturbance, mood disturbance, and anxiety'
                },
                {
                  'code': 'F02C11',
                  'description':
                      'Dementia in other diseases classified elsewhere, severe, with agitation'
                },
                {
                  'code': 'F02C18',
                  'description':
                      'Dementia in other diseases classified elsewhere, severe, with other behavioral disturbance'
                },
                {
                  'code': 'F02C2',
                  'description':
                      'Dementia in other diseases classified elsewhere, severe, with psychotic disturbance'
                },
                {
                  'code': 'F02C3',
                  'description':
                      'Dementia in other diseases classified elsewhere, severe, with mood disturbance'
                },
                {
                  'code': 'F02C4',
                  'description':
                      'Dementia in other diseases classified elsewhere, severe, with anxiety'
                },
                {
                  'code': 'F03C0',
                  'description':
                      'Unspecified dementia, severe, without behavioral disturbance, psychotic disturbance, mood disturbance, and anxiety'
                },
                {
                  'code': 'F03C11',
                  'description': 'Unspecified dementia, severe, with agitation'
                },
                {
                  'code': 'F03C18',
                  'description':
                      'Unspecified dementia, severe, with other behavioral disturbance'
                },
                {
                  'code': 'F03C2',
                  'description':
                      'Unspecified dementia, severe, with psychotic disturbance'
                },
                {
                  'code': 'F03C3',
                  'description':
                      'Unspecified dementia, severe, with mood disturbance'
                },
                {
                  'code': 'F03C4',
                  'description': 'Unspecified dementia, severe, with anxiety'
                },
              ]
            },
          ]
        },
        {
          'title': 'HCC126 - Dementia, Moderate',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'F01B0',
                  'description':
                      'Vascular dementia, moderate, without behavioral disturbance, psychotic disturbance, mood disturbance, and anxiety'
                },
                {
                  'code': 'F01B11',
                  'description': 'Vascular dementia, moderate, with agitation'
                },
                {
                  'code': 'F01B18',
                  'description':
                      'Vascular dementia, moderate, with other behavioral disturbance'
                },
                {
                  'code': 'F01B2',
                  'description':
                      'Vascular dementia, moderate, with psychotic disturbance'
                },
                {
                  'code': 'F01B3',
                  'description':
                      'Vascular dementia, moderate, with mood disturbance'
                },
                {
                  'code': 'F01B4',
                  'description': 'Vascular dementia, moderate, with anxiety'
                },
                {
                  'code': 'F02B0',
                  'description':
                      'Dementia in other diseases classified elsewhere, moderate, without behavioral disturbance, psychotic disturbance, mood disturbance, and anxiety'
                },
                {
                  'code': 'F02B11',
                  'description':
                      'Dementia in other diseases classified elsewhere, moderate, with agitation'
                },
                {
                  'code': 'F02B18',
                  'description':
                      'Dementia in other diseases classified elsewhere, moderate, with other behavioral disturbance'
                },
                {
                  'code': 'F02B2',
                  'description':
                      'Dementia in other diseases classified elsewhere, moderate, with psychotic disturbance'
                },
                {
                  'code': 'F02B3',
                  'description':
                      'Dementia in other diseases classified elsewhere, moderate, with mood disturbance'
                },
                {
                  'code': 'F02B4',
                  'description':
                      'Dementia in other diseases classified elsewhere, moderate, with anxiety'
                },
                {
                  'code': 'F03B0',
                  'description':
                      'Unspecified dementia, moderate, without behavioral disturbance, psychotic disturbance, mood disturbance, and anxiety'
                },
                {
                  'code': 'F03B11',
                  'description':
                      'Unspecified dementia, moderate, with agitation'
                },
                {
                  'code': 'F03B18',
                  'description':
                      'Unspecified dementia, moderate, with other behavioral disturbance'
                },
                {
                  'code': 'F03B2',
                  'description':
                      'Unspecified dementia, moderate, with psychotic disturbance'
                },
                {
                  'code': 'F03B3',
                  'description':
                      'Unspecified dementia, moderate, with mood disturbance'
                },
                {
                  'code': 'F03B4',
                  'description': 'Unspecified dementia, moderate, with anxiety'
                },
              ]
            },
          ]
        },
        {
          'title': 'HCC127 - Dementia, Mild or Unspecified',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'A8100',
                  'description': 'Creutzfeldt-Jakob disease, unspecified'
                },
                {
                  'code': 'A8101',
                  'description': 'Variant Creutzfeldt-Jakob disease'
                },
                {
                  'code': 'A8109',
                  'description': 'Other Creutzfeldt-Jakob disease'
                },
                {
                  'code': 'A811',
                  'description': 'Subacute sclerosing panencephalitis'
                },
                {
                  'code': 'A812',
                  'description': 'Progressive multifocal leukoencephalopathy'
                },
                {'code': 'A8181', 'description': 'Kuru'},
                {
                  'code': 'A8182',
                  'description': 'Gerstmann-Straussler-Scheinker syndrome'
                },
                {'code': 'A8183', 'description': 'Fatal familial insomnia'},
                {
                  'code': 'A8189',
                  'description':
                      'Other atypical virus infections of central nervous system'
                },
                {
                  'code': 'A819',
                  'description':
                      'Atypical virus infection of central nervous system, unspecified'
                },
                {
                  'code': 'F0150',
                  'description':
                      'Vascular dementia, unspecified severity, without behavioral disturbance, psychotic disturbance, mood disturbance, and anxiety'
                },
                {
                  'code': 'F01511',
                  'description':
                      'Vascular dementia, unspecified severity, with agitation'
                },
                {
                  'code': 'F01518',
                  'description':
                      'Vascular dementia, unspecified severity, with other behavioral disturbance'
                },
                {
                  'code': 'F0152',
                  'description':
                      'Vascular dementia, unspecified severity, with psychotic disturbance'
                },
                {
                  'code': 'F0153',
                  'description':
                      'Vascular dementia, unspecified severity, with mood disturbance'
                },
                {
                  'code': 'F0154',
                  'description':
                      'Vascular dementia, unspecified severity, with anxiety'
                },
                {
                  'code': 'F01A0',
                  'description':
                      'Vascular dementia, mild, without behavioral disturbance, psychotic disturbance, mood disturbance, and anxiety'
                },
                {
                  'code': 'F01A11',
                  'description': 'Vascular dementia, mild, with agitation'
                },
                {
                  'code': 'F01A18',
                  'description':
                      'Vascular dementia, mild, with other behavioral disturbance'
                },
                {
                  'code': 'F01A2',
                  'description':
                      'Vascular dementia, mild, with psychotic disturbance'
                },
                {
                  'code': 'F01A3',
                  'description':
                      'Vascular dementia, mild, with mood disturbance'
                },
                {
                  'code': 'F01A4',
                  'description': 'Vascular dementia, mild, with anxiety'
                },
                {
                  'code': 'F0280',
                  'description':
                      'Dementia in other diseases classified elsewhere, unspecified severity, without behavioral disturbance, psychotic disturbance, mood disturbance, and anxiety'
                },
                {
                  'code': 'F02811',
                  'description':
                      'Dementia in other diseases classified elsewhere, unspecified severity, with agitation'
                },
                {
                  'code': 'F02818',
                  'description':
                      'Dementia in other diseases classified elsewhere, unspecified severity, with other behavioral disturbance'
                },
                {
                  'code': 'F0282',
                  'description':
                      'Dementia in other diseases classified elsewhere, unspecified severity, with psychotic disturbance'
                },
                {
                  'code': 'F0283',
                  'description':
                      'Dementia in other diseases classified elsewhere, unspecified severity, with mood disturbance'
                },
                {
                  'code': 'F0284',
                  'description':
                      'Dementia in other diseases classified elsewhere, unspecified severity, with anxiety'
                },
                {
                  'code': 'F02A0',
                  'description':
                      'Dementia in other diseases classified elsewhere, mild, without behavioral disturbance, psychotic disturbance, mood disturbance, and anxiety'
                },
                {
                  'code': 'F02A11',
                  'description':
                      'Dementia in other diseases classified elsewhere, mild, with agitation'
                },
                {
                  'code': 'F02A18',
                  'description':
                      'Dementia in other diseases classified elsewhere, mild, with other behavioral disturbance'
                },
                {
                  'code': 'F02A2',
                  'description':
                      'Dementia in other diseases classified elsewhere, mild, with psychotic disturbance'
                },
                {
                  'code': 'F02A3',
                  'description':
                      'Dementia in other diseases classified elsewhere, mild, with mood disturbance'
                },
                {
                  'code': 'F02A4',
                  'description':
                      'Dementia in other diseases classified elsewhere, mild, with anxiety'
                },
                {
                  'code': 'F0390',
                  'description':
                      'Unspecified dementia, unspecified severity, without behavioral disturbance, psychotic disturbance, mood disturbance, and anxiety'
                },
                {
                  'code': 'F03911',
                  'description':
                      'Unspecified dementia, unspecified severity, with agitation'
                },
                {
                  'code': 'F03918',
                  'description':
                      'Unspecified dementia, unspecified severity, with other behavioral disturbance'
                },
                {
                  'code': 'F0392',
                  'description':
                      'Unspecified dementia, unspecified severity, with psychotic disturbance'
                },
                {
                  'code': 'F0393',
                  'description':
                      'Unspecified dementia, unspecified severity, with mood disturbance'
                },
                {
                  'code': 'F0394',
                  'description':
                      'Unspecified dementia, unspecified severity, with anxiety'
                },
                {
                  'code': 'F03A0',
                  'description':
                      'Unspecified dementia, mild, without behavioral disturbance, psychotic disturbance, mood disturbance, and anxiety'
                },
                {
                  'code': 'F03A11',
                  'description': 'Unspecified dementia, mild, with agitation'
                },
                {
                  'code': 'F03A18',
                  'description':
                      'Unspecified dementia, mild, with other behavioral disturbance'
                },
                {
                  'code': 'F03A2',
                  'description':
                      'Unspecified dementia, mild, with psychotic disturbance'
                },
                {
                  'code': 'F03A3',
                  'description':
                      'Unspecified dementia, mild, with mood disturbance'
                },
                {
                  'code': 'F03A4',
                  'description': 'Unspecified dementia, mild, with anxiety'
                },
                {
                  'code': 'G300',
                  'description': 'Alzheimer\'s disease with early onset'
                },
                {
                  'code': 'G301',
                  'description': 'Alzheimer\'s disease with late onset'
                },
                {'code': 'G308', 'description': 'Other Alzheimer\'s disease'},
                {
                  'code': 'G309',
                  'description': 'Alzheimer\'s disease, unspecified'
                },
                {'code': 'G3101', 'description': 'Pick\'s disease'},
                {
                  'code': 'G3109',
                  'description': 'Other frontotemporal neurocognitive disorder'
                },
                {'code': 'G3181', 'description': 'Alpers disease'},
                {'code': 'G3182', 'description': 'Leigh\'s disease'},
                {
                  'code': 'G3183',
                  'description': 'Neurocognitive disorder with Lewy bodies'
                },
                {'code': 'G3186', 'description': 'Alexander disease'},
                {'code': 'G910', 'description': 'Communicating hydrocephalus'},
                {'code': 'G911', 'description': 'Obstructive hydrocephalus'},
                {
                  'code': 'G912',
                  'description': '(Idiopathic) normal pressure hydrocephalus'
                },
                {
                  'code': 'G913',
                  'description': 'Post-traumatic hydrocephalus, unspecified'
                },
                {
                  'code': 'G914',
                  'description':
                      'Hydrocephalus in diseases classified elsewhere'
                },
                {'code': 'G918', 'description': 'Other hydrocephalus'},
                {'code': 'G919', 'description': 'Hydrocephalus, unspecified'},
                {'code': 'G937', 'description': 'Reye\'s syndrome'},
                {
                  'code': 'I673',
                  'description': 'Progressive vascular leukoencephalopathy'
                },
              ]
            },
          ]
        },
        {
          'title': 'HCC52 - Dementia Without Complication',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'E7500',
                  'description': 'GM2 gangliosidosis, unspecified'
                },
                {'code': 'E7501', 'description': 'Sandhoff disease'},
                {'code': 'E7502', 'description': 'Tay-Sachs disease'},
                {'code': 'E7509', 'description': 'Other GM2 gangliosidosis'},
                {'code': 'E7510', 'description': 'Unspecified gangliosidosis'},
                {'code': 'E7511', 'description': 'Mucolipidosis IV'},
                {'code': 'E7519', 'description': 'Other gangliosidosis'},
                {'code': 'E7523', 'description': 'Krabbe disease'},
                {
                  'code': 'E7525',
                  'description': 'Metachromatic leukodystrophy'
                },
                {'code': 'E7526', 'description': 'Sulfatase deficiency'},
                {
                  'code': 'E7527',
                  'description': 'Pelizaeus-Merzbacher disease'
                },
                {'code': 'E7528', 'description': 'Canavan disease'},
                {'code': 'E7529', 'description': 'Other sphingolipidosis'},
                {
                  'code': 'E754',
                  'description': 'Neuronal ceroid lipofuscinosis'
                },
                {
                  'code': 'F04',
                  'description':
                      'Amnestic disorder due to known physiological condition'
                },
                {
                  'code': 'G132',
                  'description':
                      'Systemic atrophy primarily affecting the central nervous system in myxedema'
                },
                {
                  'code': 'G138',
                  'description':
                      'Systemic atrophy primarily affecting central nervous system in other diseases classified elsewhere'
                },
                {
                  'code': 'G311',
                  'description':
                      'Senile degeneration of brain, not elsewhere classified'
                },
                {
                  'code': 'G312',
                  'description': 'Degeneration of nervous system due to alcohol'
                },
                {'code': 'G3185', 'description': 'Corticobasal degeneration'},
                {
                  'code': 'G3189',
                  'description':
                      'Other specified degenerative diseases of nervous system'
                },
                {
                  'code': 'G319',
                  'description':
                      'Degenerative disease of nervous system, unspecified'
                },
              ]
            },
          ]
        },
        {
          'title': 'RXHCC132 - Depression',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'F3281',
                  'description': 'Premenstrual dysphoric disorder'
                },
                {
                  'code': 'F3289',
                  'description': 'Other specified depressive episodes'
                },
                {
                  'code': 'F329',
                  'description':
                      'Major depressive disorder, single episode, unspecified'
                },
                {'code': 'F32A', 'description': 'Depression, unspecified'},
                {'code': 'F340', 'description': 'Cyclothymic disorder'},
                {'code': 'F341', 'description': 'Dysthymic disorder'},
                {'code': 'F530', 'description': 'Postpartum depression'},
              ]
            },
          ]
        },
        {
          'title': 'RXHCC133 - Anxiety and Other Psychiatric Disorders',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {'code': 'F4000', 'description': 'Agoraphobia, unspecified'},
                {
                  'code': 'F4001',
                  'description': 'Agoraphobia with panic disorder'
                },
                {
                  'code': 'F4002',
                  'description': 'Agoraphobia without panic disorder'
                },
                {'code': 'F4010', 'description': 'Social phobia, unspecified'},
                {'code': 'F4011', 'description': 'Social phobia, generalized'},
                {'code': 'F40210', 'description': 'Arachnophobia'},
                {'code': 'F40218', 'description': 'Other animal type phobia'},
                {'code': 'F40220', 'description': 'Fear of thunderstorms'},
                {
                  'code': 'F40228',
                  'description': 'Other natural environment type phobia'
                },
                {'code': 'F40230', 'description': 'Fear of blood'},
                {
                  'code': 'F40231',
                  'description': 'Fear of injections and transfusions'
                },
                {'code': 'F40232', 'description': 'Fear of other medical care'},
                {'code': 'F40233', 'description': 'Fear of injury'},
                {'code': 'F40240', 'description': 'Claustrophobia'},
                {'code': 'F40241', 'description': 'Acrophobia'},
                {'code': 'F40242', 'description': 'Fear of bridges'},
                {'code': 'F40243', 'description': 'Fear of flying'},
                {
                  'code': 'F40248',
                  'description': 'Other situational type phobia'
                },
                {'code': 'F40290', 'description': 'Androphobia'},
                {'code': 'F40291', 'description': 'Gynephobia'},
                {'code': 'F40298', 'description': 'Other specified phobia'},
                {
                  'code': 'F408',
                  'description': 'Other phobic anxiety disorders'
                },
                {
                  'code': 'F409',
                  'description': 'Phobic anxiety disorder, unspecified'
                },
                {
                  'code': 'F410',
                  'description': 'Panic disorder [episodic paroxysmal anxiety]'
                },
                {'code': 'F411', 'description': 'Generalized anxiety disorder'},
                {
                  'code': 'F422',
                  'description': 'Mixed obsessional thoughts and acts'
                },
                {'code': 'F423', 'description': 'Hoarding disorder'},
                {
                  'code': 'F424',
                  'description': 'Excoriation (skin-picking) disorder'
                },
                {
                  'code': 'F428',
                  'description': 'Other obsessive-compulsive disorder'
                },
                {
                  'code': 'F429',
                  'description': 'Obsessive-compulsive disorder, unspecified'
                },
                {
                  'code': 'F4310',
                  'description': 'Post-traumatic stress disorder, unspecified'
                },
                {
                  'code': 'F4311',
                  'description': 'Post-traumatic stress disorder, acute'
                },
                {
                  'code': 'F4312',
                  'description': 'Post-traumatic stress disorder, chronic'
                },
                {
                  'code': 'F4320',
                  'description': 'Adjustment disorder, unspecified'
                },
                {
                  'code': 'F4321',
                  'description': 'Adjustment disorder with depressed mood'
                },
                {
                  'code': 'F4322',
                  'description': 'Adjustment disorder with anxiety'
                },
                {
                  'code': 'F4323',
                  'description':
                      'Adjustment disorder with mixed anxiety and depressed mood'
                },
                {
                  'code': 'F4324',
                  'description':
                      'Adjustment disorder with disturbance of conduct'
                },
                {
                  'code': 'F4325',
                  'description':
                      'Adjustment disorder with mixed disturbance of emotions and conduct'
                },
                {
                  'code': 'F4329',
                  'description': 'Adjustment disorder with other symptoms'
                },
                {'code': 'F442', 'description': 'Dissociative stupor'},
                {
                  'code': 'F444',
                  'description':
                      'Conversion disorder with motor symptom or deficit'
                },
                {
                  'code': 'F445',
                  'description':
                      'Conversion disorder with seizures or convulsions'
                },
                {
                  'code': 'F446',
                  'description':
                      'Conversion disorder with sensory symptom or deficit'
                },
                {
                  'code': 'F447',
                  'description':
                      'Conversion disorder with mixed symptom presentation'
                },
                {
                  'code': 'F4489',
                  'description': 'Other dissociative and conversion disorders'
                },
                {
                  'code': 'F449',
                  'description':
                      'Dissociative and conversion disorder, unspecified'
                },
                {'code': 'F450', 'description': 'Somatization disorder'},
                {
                  'code': 'F451',
                  'description': 'Undifferentiated somatoform disorder'
                },
                {
                  'code': 'F4520',
                  'description': 'Hypochondriacal disorder, unspecified'
                },
                {'code': 'F4521', 'description': 'Hypochondriasis'},
                {'code': 'F4522', 'description': 'Body dysmorphic disorder'},
                {
                  'code': 'F4529',
                  'description': 'Other hypochondriacal disorders'
                },
                {'code': 'F458', 'description': 'Other somatoform disorders'},
                {
                  'code': 'F459',
                  'description': 'Somatoform disorder, unspecified'
                },
                {'code': 'F5081', 'description': 'Binge eating disorder'},
                {
                  'code': 'F50810',
                  'description': 'Binge eating disorder, mild'
                },
                {
                  'code': 'F50811',
                  'description': 'Binge eating disorder, moderate'
                },
                {
                  'code': 'F50812',
                  'description': 'Binge eating disorder, severe'
                },
                {
                  'code': 'F50813',
                  'description': 'Binge eating disorder, extreme'
                },
                {
                  'code': 'F50814',
                  'description': 'Binge eating disorder, in remission'
                },
                {
                  'code': 'F50819',
                  'description': 'Binge eating disorder, unspecified'
                },
                {
                  'code': 'F5082',
                  'description': 'Avoidant/restrictive food intake disorder'
                },
                {'code': 'F5083', 'description': 'Pica in adults'},
                {
                  'code': 'F5084',
                  'description': 'Rumination disorder in adults'
                },
                {
                  'code': 'F5089',
                  'description': 'Other specified eating disorder'
                },
                {'code': 'F509', 'description': 'Eating disorder, unspecified'},
                {'code': 'F630', 'description': 'Pathological gambling'},
                {'code': 'F631', 'description': 'Pyromania'},
                {'code': 'F632', 'description': 'Kleptomania'},
                {'code': 'F633', 'description': 'Trichotillomania'},
                {
                  'code': 'F6381',
                  'description': 'Intermittent explosive disorder'
                },
                {'code': 'F6389', 'description': 'Other impulse disorders'},
                {
                  'code': 'F639',
                  'description': 'Impulse disorder, unspecified'
                },
                {
                  'code': 'F6810',
                  'description':
                      'Factitious disorder imposed on self, unspecified'
                },
                {
                  'code': 'F6811',
                  'description':
                      'Factitious disorder imposed on self, with predominantly psychological signs and symptoms'
                },
                {
                  'code': 'F6812',
                  'description':
                      'Factitious disorder imposed on self, with predominantly physical signs and symptoms'
                },
                {
                  'code': 'F6813',
                  'description':
                      'Factitious disorder imposed on self, with combined psychological and physical signs and symptoms'
                },
                {
                  'code': 'F68A',
                  'description': 'Factitious disorder imposed on another'
                },
                {'code': 'F840', 'description': 'Autistic disorder'},
                {'code': 'F842', 'description': 'Rett\'s syndrome'},
                {
                  'code': 'F843',
                  'description': 'Other childhood disintegrative disorder'
                },
                {'code': 'F845', 'description': 'Asperger\'s syndrome'},
                {
                  'code': 'F848',
                  'description': 'Other pervasive developmental disorders'
                },
                {
                  'code': 'F849',
                  'description': 'Pervasive developmental disorder, unspecified'
                },
                {
                  'code': 'F900',
                  'description':
                      'Attention-deficit hyperactivity disorder, predominantly inattentive type'
                },
                {
                  'code': 'F901',
                  'description':
                      'Attention-deficit hyperactivity disorder, predominantly hyperactive type'
                },
                {
                  'code': 'F902',
                  'description':
                      'Attention-deficit hyperactivity disorder, combined type'
                },
                {
                  'code': 'F908',
                  'description':
                      'Attention-deficit hyperactivity disorder, other type'
                },
                {
                  'code': 'F909',
                  'description':
                      'Attention-deficit hyperactivity disorder, unspecified type'
                },
                {
                  'code': 'F910',
                  'description': 'Conduct disorder confined to family context'
                },
                {
                  'code': 'F911',
                  'description': 'Conduct disorder, childhood-onset type'
                },
                {
                  'code': 'F912',
                  'description': 'Conduct disorder, adolescent-onset type'
                },
                {
                  'code': 'F913',
                  'description': 'Oppositional defiant disorder'
                },
                {'code': 'F918', 'description': 'Other conduct disorders'},
                {
                  'code': 'F919',
                  'description': 'Conduct disorder, unspecified'
                },
                {
                  'code': 'F930',
                  'description': 'Separation anxiety disorder of childhood'
                },
                {'code': 'F950', 'description': 'Transient tic disorder'},
                {
                  'code': 'F951',
                  'description': 'Chronic motor or vocal tic disorder'
                },
                {'code': 'F952', 'description': 'Tourette\'s disorder'},
                {'code': 'F958', 'description': 'Other tic disorders'},
                {'code': 'F959', 'description': 'Tic disorder, unspecified'},
                {
                  'code': 'F9821',
                  'description': 'Rumination disorder of infancy and childhood'
                },
                {
                  'code': 'F9829',
                  'description':
                      'Other feeding disorders of infancy and early childhood'
                },
                {
                  'code': 'F983',
                  'description': 'Pica of infancy and childhood'
                },
                {
                  'code': 'F984',
                  'description': 'Stereotyped movement disorders'
                },
              ]
            },
          ]
        },
        {
          'title':
              'RXHCC146 - Profound or Severe Intellectual Disability/Developmental Disorder',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'F72',
                  'description': 'Severe intellectual disabilities'
                },
                {
                  'code': 'F73',
                  'description': 'Profound intellectual disabilities'
                },
              ]
            },
          ]
        },
        {
          'title':
              'RXHCC147 - Moderate Intellectual Disability/Developmental Disorder',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'F71',
                  'description': 'Moderate intellectual disabilities'
                },
                {
                  'code': 'F78A1',
                  'description': 'SYNGAP1-related intellectual disability'
                },
              ]
            },
          ]
        },
        {
          'title':
              'RXHCC148 - Mild or Unspecified Intellectual Disability/Developmental Disorder',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'F70',
                  'description': 'Mild intellectual disabilities'
                },
                {
                  'code': 'F78A9',
                  'description': 'Other genetic related intellectual disability'
                },
                {
                  'code': 'F79',
                  'description': 'Unspecified intellectual disabilities'
                },
                {'code': 'Q8711', 'description': 'Prader-Willi syndrome'},
                {'code': 'Q8786', 'description': 'Kleefstra syndrome'},
              ]
            },
          ]
        },
      ]
    },
    {
      'title': 'DIABETES DISEASE GROUP',
      'sections': [
        {
          'title': 'HCC37 - Diabetes with Chronic Complications',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'E0800',
                  'description':
                      'Diabetes mellitus due to underlying condition with hyperosmolarity without nonketotic hyperglycemic-hyperosmolar coma (NKHHC)'
                },
                {
                  'code': 'E0801',
                  'description':
                      'Diabetes mellitus due to underlying condition with hyperosmolarity with coma'
                },
                {
                  'code': 'E0810',
                  'description':
                      'Diabetes mellitus due to underlying condition with ketoacidosis without coma'
                },
                {
                  'code': 'E0811',
                  'description':
                      'Diabetes mellitus due to underlying condition with ketoacidosis with coma'
                },
                {
                  'code': 'E0821',
                  'description':
                      'Diabetes mellitus due to underlying condition with diabetic nephropathy'
                },
                {
                  'code': 'E0822',
                  'description':
                      'Diabetes mellitus due to underlying condition with diabetic chronic kidney disease'
                },
                {
                  'code': 'E0829',
                  'description':
                      'Diabetes mellitus due to underlying condition with other diabetic kidney complication'
                },
                {
                  'code': 'E08311',
                  'description':
                      'Diabetes mellitus due to underlying condition with unspecified diabetic retinopathy with macular edema'
                },
                {
                  'code': 'E08319',
                  'description':
                      'Diabetes mellitus due to underlying condition with unspecified diabetic retinopathy without macular edema'
                },
                {
                  'code': 'E083211',
                  'description':
                      'Diabetes mellitus due to underlying condition with mild nonproliferative diabetic retinopathy with macular edema, right eye'
                },
                {
                  'code': 'E083212',
                  'description':
                      'Diabetes mellitus due to underlying condition with mild nonproliferative diabetic retinopathy with macular edema, left eye'
                },
                {
                  'code': 'E083213',
                  'description':
                      'Diabetes mellitus due to underlying condition with mild nonproliferative diabetic retinopathy with macular edema, bilateral'
                },
                {
                  'code': 'E083219',
                  'description':
                      'Diabetes mellitus due to underlying condition with mild nonproliferative diabetic retinopathy with macular edema, unspecified eye'
                },
                {
                  'code': 'E083291',
                  'description':
                      'Diabetes mellitus due to underlying condition with mild nonproliferative diabetic retinopathy without macular edema, right eye'
                },
                {
                  'code': 'E083292',
                  'description':
                      'Diabetes mellitus due to underlying condition with mild nonproliferative diabetic retinopathy without macular edema, left eye'
                },
                {
                  'code': 'E083293',
                  'description':
                      'Diabetes mellitus due to underlying condition with mild nonproliferative diabetic retinopathy without macular edema, bilateral'
                },
                {
                  'code': 'E083299',
                  'description':
                      'Diabetes mellitus due to underlying condition with mild nonproliferative diabetic retinopathy without macular edema, unspecified eye'
                },
                {
                  'code': 'E083311',
                  'description':
                      'Diabetes mellitus due to underlying condition with moderate nonproliferative diabetic retinopathy with macular edema, right eye'
                },
                {
                  'code': 'E083312',
                  'description':
                      'Diabetes mellitus due to underlying condition with moderate nonproliferative diabetic retinopathy with macular edema, left eye'
                },
                {
                  'code': 'E083313',
                  'description':
                      'Diabetes mellitus due to underlying condition with moderate nonproliferative diabetic retinopathy with macular edema, bilateral'
                },
                {
                  'code': 'E083319',
                  'description':
                      'Diabetes mellitus due to underlying condition with moderate nonproliferative diabetic retinopathy with macular edema, unspecified eye'
                },
                {
                  'code': 'E083391',
                  'description':
                      'Diabetes mellitus due to underlying condition with moderate nonproliferative diabetic retinopathy without macular edema, right eye'
                },
                {
                  'code': 'E083392',
                  'description':
                      'Diabetes mellitus due to underlying condition with moderate nonproliferative diabetic retinopathy without macular edema, left eye'
                },
                {
                  'code': 'E083393',
                  'description':
                      'Diabetes mellitus due to underlying condition with moderate nonproliferative diabetic retinopathy without macular edema, bilateral'
                },
                {
                  'code': 'E083399',
                  'description':
                      'Diabetes mellitus due to underlying condition with moderate nonproliferative diabetic retinopathy without macular edema, unspecified eye'
                },
                {
                  'code': 'E083411',
                  'description':
                      'Diabetes mellitus due to underlying condition with severe nonproliferative diabetic retinopathy with macular edema, right eye'
                },
                {
                  'code': 'E083412',
                  'description':
                      'Diabetes mellitus due to underlying condition with severe nonproliferative diabetic retinopathy with macular edema, left eye'
                },
                {
                  'code': 'E083413',
                  'description':
                      'Diabetes mellitus due to underlying condition with severe nonproliferative diabetic retinopathy with macular edema, bilateral'
                },
                {
                  'code': 'E083419',
                  'description':
                      'Diabetes mellitus due to underlying condition with severe nonproliferative diabetic retinopathy with macular edema, unspecified eye'
                },
                {
                  'code': 'E083491',
                  'description':
                      'Diabetes mellitus due to underlying condition with severe nonproliferative diabetic retinopathy without macular edema, right eye'
                },
                {
                  'code': 'E083492',
                  'description':
                      'Diabetes mellitus due to underlying condition with severe nonproliferative diabetic retinopathy without macular edema, left eye'
                },
                {
                  'code': 'E083493',
                  'description':
                      'Diabetes mellitus due to underlying condition with severe nonproliferative diabetic retinopathy without macular edema, bilateral'
                },
                {
                  'code': 'E083499',
                  'description':
                      'Diabetes mellitus due to underlying condition with severe nonproliferative diabetic retinopathy without macular edema, unspecified eye'
                },
              ]
            },
          ]
        },
        {
          'title':
              'HCC38 - Diabetes with Glycemic, Unspecified, or No Complications',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'E1369',
                  'description':
                      'Other specified diabetes mellitus with other specified complication'
                },
                {
                  'code': 'E08649',
                  'description':
                      'Diabetes mellitus due to underlying condition with hypoglycemia without coma'
                },
                {
                  'code': 'E0865',
                  'description':
                      'Diabetes mellitus due to underlying condition with hyperglycemia'
                },
                {
                  'code': 'E088',
                  'description':
                      'Diabetes mellitus due to underlying condition with unspecified complications'
                },
                {
                  'code': 'E089',
                  'description':
                      'Diabetes mellitus due to underlying condition without complications'
                },
                {
                  'code': 'E10649',
                  'description':
                      'Type 1 diabetes mellitus with hypoglycemia without coma'
                },
                {
                  'code': 'E1065',
                  'description': 'Type 1 diabetes mellitus with hyperglycemia'
                },
                {
                  'code': 'E108',
                  'description':
                      'Type 1 diabetes mellitus with unspecified complications'
                },
                {
                  'code': 'E109',
                  'description':
                      'Type 1 diabetes mellitus without complications'
                },
                {
                  'code': 'E11649',
                  'description':
                      'Type 2 diabetes mellitus with hypoglycemia without coma'
                },
                {
                  'code': 'E1165',
                  'description': 'Type 2 diabetes mellitus with hyperglycemia'
                },
                {
                  'code': 'E118',
                  'description':
                      'Type 2 diabetes mellitus with unspecified complications'
                },
                {
                  'code': 'E119',
                  'description':
                      'Type 2 diabetes mellitus without complications'
                },
                {
                  'code': 'E13649',
                  'description':
                      'Other specified diabetes mellitus with hypoglycemia without coma'
                },
                {
                  'code': 'E1365',
                  'description':
                      'Other specified diabetes mellitus with hyperglycemia'
                },
                {
                  'code': 'E138',
                  'description':
                      'Other specified diabetes mellitus with unspecified complications'
                },
                {
                  'code': 'E139',
                  'description':
                      'Other specified diabetes mellitus without complications'
                },
                {
                  'code': 'Z794',
                  'description': 'Long term (current) use of insulin'
                },
              ]
            },
          ]
        },
        {
          'title':
              'HCC18 - Diabetes with Chronic Complications (Drug/Chemical Induced)',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'C770',
                  'description':
                      'Secondary and unspecified malignant neoplasm of lymph nodes of head, face and neck'
                },
                {
                  'code': 'C772',
                  'description':
                      'Secondary and unspecified malignant neoplasm of intra-abdominal lymph nodes'
                },
                {
                  'code': 'C774',
                  'description':
                      'Secondary and unspecified malignant neoplasm of inguinal and lower limb lymph nodes'
                },
                {
                  'code': 'C775',
                  'description':
                      'Secondary and unspecified malignant neoplasm of intrapelvic lymph nodes'
                },
                {
                  'code': 'C779',
                  'description':
                      'Secondary and unspecified malignant neoplasm of lymph node, unspecified'
                },
                {
                  'code': 'C7910',
                  'description':
                      'Secondary malignant neoplasm of unspecified urinary organs'
                },
                {
                  'code': 'C7911',
                  'description': 'Secondary malignant neoplasm of bladder'
                },
                {
                  'code': 'C7919',
                  'description':
                      'Secondary malignant neoplasm of other urinary organs'
                },
                {
                  'code': 'C792',
                  'description': 'Secondary malignant neoplasm of skin'
                },
                {
                  'code': 'C7951',
                  'description': 'Secondary malignant neoplasm of bone'
                },
                {
                  'code': 'C7952',
                  'description': 'Secondary malignant neoplasm of bone marrow'
                },
                {
                  'code': 'C7960',
                  'description':
                      'Secondary malignant neoplasm of unspecified ovary'
                },
                {
                  'code': 'C7961',
                  'description': 'Secondary malignant neoplasm of right ovary'
                },
                {
                  'code': 'C7962',
                  'description': 'Secondary malignant neoplasm of left ovary'
                },
                {
                  'code': 'C7963',
                  'description':
                      'Secondary malignant neoplasm of bilateral ovaries'
                },
                {
                  'code': 'C7981',
                  'description': 'Secondary malignant neoplasm of breast'
                },
                {
                  'code': 'C7982',
                  'description':
                      'Secondary malignant neoplasm of genital organs'
                },
                {
                  'code': 'C7989',
                  'description':
                      'Secondary malignant neoplasm of other specified sites'
                },
                {
                  'code': 'C799',
                  'description':
                      'Secondary malignant neoplasm of unspecified site'
                },
                {
                  'code': 'C800',
                  'description': 'Disseminated malignant neoplasm, unspecified'
                },
                {
                  'code': 'C9100',
                  'description':
                      'Acute lymphoblastic leukemia not having achieved remission'
                },
                {
                  'code': 'C9101',
                  'description': 'Acute lymphoblastic leukemia, in remission'
                },
                {
                  'code': 'C9102',
                  'description': 'Acute lymphoblastic leukemia, in relapse'
                },
                {
                  'code': 'C9500',
                  'description':
                      'Acute leukemia of unspecified cell type not having achieved remission'
                },
                {
                  'code': 'C9501',
                  'description':
                      'Acute leukemia of unspecified cell type, in remission'
                },
                {
                  'code': 'C9502',
                  'description':
                      'Acute leukemia of unspecified cell type, in relapse'
                },
                {
                  'code': 'E0921',
                  'description':
                      'Drug or chemical induced diabetes mellitus with diabetic nephropathy'
                },
                {
                  'code': 'E0922',
                  'description':
                      'Drug or chemical induced diabetes mellitus with diabetic chronic kidney disease'
                },
                {
                  'code': 'E0929',
                  'description':
                      'Drug or chemical induced diabetes mellitus with other diabetic kidney complication'
                },
                {
                  'code': 'E09311',
                  'description':
                      'Drug or chemical induced diabetes mellitus with unspecified diabetic retinopathy with macular edema'
                },
                {
                  'code': 'E09319',
                  'description':
                      'Drug or chemical induced diabetes mellitus with unspecified diabetic retinopathy without macular edema'
                },
                {
                  'code': 'E093211',
                  'description':
                      'Drug or chemical induced diabetes mellitus with mild nonproliferative diabetic retinopathy with macular edema, right eye'
                },
                {
                  'code': 'E093212',
                  'description':
                      'Drug or chemical induced diabetes mellitus with mild nonproliferative diabetic retinopathy with macular edema, left eye'
                },
                {
                  'code': 'E093213',
                  'description':
                      'Drug or chemical induced diabetes mellitus with mild nonproliferative diabetic retinopathy with macular edema, bilateral'
                },
                {
                  'code': 'E093219',
                  'description':
                      'Drug or chemical induced diabetes mellitus with mild nonproliferative diabetic retinopathy with macular edema, unspecified eye'
                },
                {
                  'code': 'E093291',
                  'description':
                      'Drug or chemical induced diabetes mellitus with mild nonproliferative diabetic retinopathy without macular edema, right eye'
                },
                {
                  'code': 'E093292',
                  'description':
                      'Drug or chemical induced diabetes mellitus with mild nonproliferative diabetic retinopathy without macular edema, left eye'
                },
                {
                  'code': 'E093293',
                  'description':
                      'Drug or chemical induced diabetes mellitus with mild nonproliferative diabetic retinopathy without macular edema, bilateral'
                },
                {
                  'code': 'E093299',
                  'description':
                      'Drug or chemical induced diabetes mellitus with mild nonproliferative diabetic retinopathy without macular edema, unspecified eye'
                },
                {
                  'code': 'E093311',
                  'description':
                      'Drug or chemical induced diabetes mellitus with moderate nonproliferative diabetic retinopathy with macular edema, right eye'
                },
                {
                  'code': 'E093312',
                  'description':
                      'Drug or chemical induced diabetes mellitus with moderate nonproliferative diabetic retinopathy with macular edema, left eye'
                },
                {
                  'code': 'E093313',
                  'description':
                      'Drug or chemical induced diabetes mellitus with moderate nonproliferative diabetic retinopathy with macular edema, bilateral'
                },
                {
                  'code': 'E093319',
                  'description':
                      'Drug or chemical induced diabetes mellitus with moderate nonproliferative diabetic retinopathy with macular edema, unspecified eye'
                },
                {
                  'code': 'E093391',
                  'description':
                      'Drug or chemical induced diabetes mellitus with moderate nonproliferative diabetic retinopathy without macular edema, right eye'
                },
                {
                  'code': 'E093392',
                  'description':
                      'Drug or chemical induced diabetes mellitus with moderate nonproliferative diabetic retinopathy without macular edema, left eye'
                },
                {
                  'code': 'E093393',
                  'description':
                      'Drug or chemical induced diabetes mellitus with moderate nonproliferative diabetic retinopathy without macular edema, bilateral'
                },
                {
                  'code': 'E093399',
                  'description':
                      'Drug or chemical induced diabetes mellitus with moderate nonproliferative diabetic retinopathy without macular edema, unspecified eye'
                },
                {
                  'code': 'E093411',
                  'description':
                      'Drug or chemical induced diabetes mellitus with severe nonproliferative diabetic retinopathy with macular edema, right eye'
                },
                {
                  'code': 'E093412',
                  'description':
                      'Drug or chemical induced diabetes mellitus with severe nonproliferative diabetic retinopathy with macular edema, left eye'
                },
                {
                  'code': 'E093413',
                  'description':
                      'Drug or chemical induced diabetes mellitus with severe nonproliferative diabetic retinopathy with macular edema, bilateral'
                },
                {
                  'code': 'E093419',
                  'description':
                      'Drug or chemical induced diabetes mellitus with severe nonproliferative diabetic retinopathy with macular edema, unspecified eye'
                },
                {
                  'code': 'E093491',
                  'description':
                      'Drug or chemical induced diabetes mellitus with severe nonproliferative diabetic retinopathy without macular edema, right eye'
                },
                {
                  'code': 'E093492',
                  'description':
                      'Drug or chemical induced diabetes mellitus with severe nonproliferative diabetic retinopathy without macular edema, left eye'
                },
                {
                  'code': 'E093493',
                  'description':
                      'Drug or chemical induced diabetes mellitus with severe nonproliferative diabetic retinopathy without macular edema, bilateral'
                },
                {
                  'code': 'E093499',
                  'description':
                      'Drug or chemical induced diabetes mellitus with severe nonproliferative diabetic retinopathy without macular edema, unspecified eye'
                },
                {
                  'code': 'E093511',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with macular edema, right eye'
                },
                {
                  'code': 'E093512',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with macular edema, left eye'
                },
                {
                  'code': 'E093513',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with macular edema, bilateral'
                },
                {
                  'code': 'E093519',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with macular edema, unspecified eye'
                },
                {
                  'code': 'E093521',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with traction retinal detachment involving the macula, right eye'
                },
                {
                  'code': 'E093522',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with traction retinal detachment involving the macula, left eye'
                },
                {
                  'code': 'E093523',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with traction retinal detachment involving the macula, bilateral'
                },
                {
                  'code': 'E093529',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with traction retinal detachment involving the macula, unspecified eye'
                },
                {
                  'code': 'E093531',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with traction retinal detachment not involving the macula, right eye'
                },
                {
                  'code': 'E093532',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with traction retinal detachment not involving the macula, left eye'
                },
                {
                  'code': 'E093533',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with traction retinal detachment not involving the macula, bilateral'
                },
                {
                  'code': 'E093539',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with traction retinal detachment not involving the macula, unspecified eye'
                },
                {
                  'code': 'E093541',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with combined traction retinal detachment and rhegmatogenous retinal detachment, right eye'
                },
                {
                  'code': 'E093542',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with combined traction retinal detachment and rhegmatogenous retinal detachment, left eye'
                },
                {
                  'code': 'E093543',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with combined traction retinal detachment and rhegmatogenous retinal detachment, bilateral'
                },
                {
                  'code': 'E093549',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with combined traction retinal detachment and rhegmatogenous retinal detachment, unspecified eye'
                },
                {
                  'code': 'E093551',
                  'description':
                      'Drug or chemical induced diabetes mellitus with stable proliferative diabetic retinopathy, right eye'
                },
                {
                  'code': 'E093552',
                  'description':
                      'Drug or chemical induced diabetes mellitus with stable proliferative diabetic retinopathy, left eye'
                },
                {
                  'code': 'E093553',
                  'description':
                      'Drug or chemical induced diabetes mellitus with stable proliferative diabetic retinopathy, bilateral'
                },
                {
                  'code': 'E093559',
                  'description':
                      'Drug or chemical induced diabetes mellitus with stable proliferative diabetic retinopathy, unspecified eye'
                },
                {
                  'code': 'E093591',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy without macular edema, right eye'
                },
                {
                  'code': 'E093592',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy without macular edema, left eye'
                },
                {
                  'code': 'E093593',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy without macular edema, bilateral'
                },
                {
                  'code': 'E093599',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy without macular edema, unspecified eye'
                },
                {
                  'code': 'E0936',
                  'description':
                      'Drug or chemical induced diabetes mellitus with diabetic cataract'
                },
                {
                  'code': 'E0937X1',
                  'description':
                      'Drug or chemical induced diabetes mellitus with diabetic macular edema, resolved following treatment, right eye'
                },
                {
                  'code': 'E0937X2',
                  'description':
                      'Drug or chemical induced diabetes mellitus with diabetic macular edema, resolved following treatment, left eye'
                },
                {
                  'code': 'E0937X3',
                  'description':
                      'Drug or chemical induced diabetes mellitus with diabetic macular edema, resolved following treatment, bilateral'
                },
                {
                  'code': 'E0937X9',
                  'description':
                      'Drug or chemical induced diabetes mellitus with diabetic macular edema, resolved following treatment, unspecified eye'
                },
                {
                  'code': 'E0939',
                  'description':
                      'Drug or chemical induced diabetes mellitus with other diabetic ophthalmic complication'
                },
                {
                  'code': 'E0940',
                  'description':
                      'Drug or chemical induced diabetes mellitus with diabetic neuropathy, unspecified'
                },
                {
                  'code': 'E0941',
                  'description':
                      'Drug or chemical induced diabetes mellitus with diabetic mononeuropathy'
                },
                {
                  'code': 'E0942',
                  'description':
                      'Drug or chemical induced diabetes mellitus with diabetic polyneuropathy'
                },
                {
                  'code': 'E0943',
                  'description':
                      'Drug or chemical induced diabetes mellitus with diabetic autonomic (poly)neuropathy'
                },
                {
                  'code': 'E0944',
                  'description':
                      'Drug or chemical induced diabetes mellitus with diabetic amyotrophy'
                },
                {
                  'code': 'E0949',
                  'description':
                      'Drug or chemical induced diabetes mellitus with other diabetic neurological complication'
                },
                {
                  'code': 'E0951',
                  'description':
                      'Drug or chemical induced diabetes mellitus with diabetic peripheral angiopathy without gangrene'
                },
                {
                  'code': 'E0952',
                  'description':
                      'Drug or chemical induced diabetes mellitus with diabetic peripheral angiopathy with gangrene'
                },
                {
                  'code': 'E0959',
                  'description':
                      'Drug or chemical induced diabetes mellitus with other circulatory complications'
                },
                {
                  'code': 'E09610',
                  'description':
                      'Drug or chemical induced diabetes mellitus with diabetic neuropathic arthropathy'
                },
                {
                  'code': 'E09618',
                  'description':
                      'Drug or chemical induced diabetes mellitus with other diabetic arthropathy'
                },
                {
                  'code': 'E09620',
                  'description':
                      'Drug or chemical induced diabetes mellitus with diabetic dermatitis'
                },
                {
                  'code': 'E09621',
                  'description':
                      'Drug or chemical induced diabetes mellitus with foot ulcer'
                },
                {
                  'code': 'E09622',
                  'description':
                      'Drug or chemical induced diabetes mellitus with other skin ulcer'
                },
                {
                  'code': 'E09628',
                  'description':
                      'Drug or chemical induced diabetes mellitus with other skin complications'
                },
                {
                  'code': 'E09630',
                  'description':
                      'Drug or chemical induced diabetes mellitus with periodontal disease'
                },
                {
                  'code': 'E09638',
                  'description':
                      'Drug or chemical induced diabetes mellitus with other oral complications'
                },
                {
                  'code': 'E09641',
                  'description':
                      'Drug or chemical induced diabetes mellitus with hypoglycemia with coma'
                },
                {
                  'code': 'E09649',
                  'description':
                      'Drug or chemical induced diabetes mellitus with hypoglycemia without coma'
                },
                {
                  'code': 'E0965',
                  'description':
                      'Drug or chemical induced diabetes mellitus with hyperglycemia'
                },
                {
                  'code': 'E0969',
                  'description':
                      'Drug or chemical induced diabetes mellitus with other specified complication'
                },
                {
                  'code': 'E098',
                  'description':
                      'Drug or chemical induced diabetes mellitus with unspecified complications'
                },
              ]
            },
          ]
        },
        {
          'title': 'HCC19 - Diabetes without Complication',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {'code': 'C450', 'description': 'Mesothelioma of pleura'},
                {'code': 'C451', 'description': 'Mesothelioma of peritoneum'},
                {'code': 'C452', 'description': 'Mesothelioma of pericardium'},
                {'code': 'C457', 'description': 'Mesothelioma of other sites'},
                {'code': 'C459', 'description': 'Mesothelioma, unspecified'},
                {
                  'code': 'C8440',
                  'description':
                      'Peripheral T-cell lymphoma, not elsewhere classified, unspecified site'
                },
                {
                  'code': 'C8441',
                  'description':
                      'Peripheral T-cell lymphoma, not elsewhere classified, lymph nodes of head, face, and neck'
                },
                {
                  'code': 'C8442',
                  'description':
                      'Peripheral T-cell lymphoma, not elsewhere classified, intrathoracic lymph nodes'
                },
                {
                  'code': 'C8443',
                  'description':
                      'Peripheral T-cell lymphoma, not elsewhere classified, intra-abdominal lymph nodes'
                },
                {
                  'code': 'C8444',
                  'description':
                      'Peripheral T-cell lymphoma, not elsewhere classified, lymph nodes of axilla and upper limb'
                },
                {
                  'code': 'C8445',
                  'description':
                      'Peripheral T-cell lymphoma, not elsewhere classified, lymph nodes of inguinal region and lower limb'
                },
                {
                  'code': 'C8446',
                  'description':
                      'Peripheral T-cell lymphoma, not elsewhere classified, intrapelvic lymph nodes'
                },
                {
                  'code': 'C8447',
                  'description':
                      'Peripheral T-cell lymphoma, not elsewhere classified, spleen'
                },
                {
                  'code': 'C8448',
                  'description':
                      'Peripheral T-cell lymphoma, not elsewhere classified, lymph nodes of multiple sites'
                },
                {
                  'code': 'C8449',
                  'description':
                      'Peripheral T-cell lymphoma, not elsewhere classified, extranodal and solid organ sites'
                },
                {
                  'code': 'C844A',
                  'description':
                      'Peripheral T-cell lymphoma, not elsewhere classified, in remission'
                },
                {
                  'code': 'C8470',
                  'description':
                      'Anaplastic large cell lymphoma, ALK-negative, unspecified site'
                },
                {
                  'code': 'C8471',
                  'description':
                      'Anaplastic large cell lymphoma, ALK-negative, lymph nodes of head, face, and neck'
                },
                {
                  'code': 'C8472',
                  'description':
                      'Anaplastic large cell lymphoma, ALK-negative, intrathoracic lymph nodes'
                },
                {
                  'code': 'C8473',
                  'description':
                      'Anaplastic large cell lymphoma, ALK-negative, intra-abdominal lymph nodes'
                },
                {
                  'code': 'C8474',
                  'description':
                      'Anaplastic large cell lymphoma, ALK-negative, lymph nodes of axilla and upper limb'
                },
                {
                  'code': 'C8475',
                  'description':
                      'Anaplastic large cell lymphoma, ALK-negative, lymph nodes of inguinal region and lower limb'
                },
                {
                  'code': 'C8476',
                  'description':
                      'Anaplastic large cell lymphoma, ALK-negative, intrapelvic lymph nodes'
                },
                {
                  'code': 'C8477',
                  'description':
                      'Anaplastic large cell lymphoma, ALK-negative, spleen'
                },
                {
                  'code': 'C8478',
                  'description':
                      'Anaplastic large cell lymphoma, ALK-negative, lymph nodes of multiple sites'
                },
                {
                  'code': 'C8479',
                  'description':
                      'Anaplastic large cell lymphoma, ALK-negative, extranodal and solid organ sites'
                },
                {
                  'code': 'C847A',
                  'description':
                      'Anaplastic large cell lymphoma, ALK-negative, breast'
                },
                {
                  'code': 'C847B',
                  'description':
                      'Anaplastic large cell lymphoma, ALK-negative, in remission'
                },
                {
                  'code': 'C863',
                  'description':
                      'Subcutaneous panniculitis-like T-cell lymphoma'
                },
                {
                  'code': 'C8630',
                  'description':
                      'Subcutaneous panniculitis-like T-cell lymphoma not having achieved remission'
                },
                {
                  'code': 'C8631',
                  'description':
                      'Subcutaneous panniculitis-like T-cell lymphoma, in remission'
                },
                {'code': 'C864', 'description': 'Blastic NK-cell lymphoma'},
                {
                  'code': 'C8640',
                  'description':
                      'Blastic NK-cell lymphoma not having achieved remission'
                },
                {
                  'code': 'C8641',
                  'description': 'Blastic NK-cell lymphoma, in remission'
                },
                {
                  'code': 'C865',
                  'description': 'Angioimmunoblastic T-cell lymphoma'
                },
                {
                  'code': 'C8650',
                  'description':
                      'Angioimmunoblastic T-cell lymphoma not having achieved remission'
                },
                {
                  'code': 'C8651',
                  'description':
                      'Angioimmunoblastic T-cell lymphoma, in remission'
                },
                {
                  'code': 'C9000',
                  'description':
                      'Multiple myeloma not having achieved remission'
                },
                {
                  'code': 'C9001',
                  'description': 'Multiple myeloma in remission'
                },
                {'code': 'C9002', 'description': 'Multiple myeloma in relapse'},
                {
                  'code': 'C9010',
                  'description':
                      'Plasma cell leukemia not having achieved remission'
                },
                {
                  'code': 'C9011',
                  'description': 'Plasma cell leukemia in remission'
                },
                {
                  'code': 'C9012',
                  'description': 'Plasma cell leukemia in relapse'
                },
                {
                  'code': 'C9020',
                  'description':
                      'Extramedullary plasmacytoma not having achieved remission'
                },
                {
                  'code': 'C9021',
                  'description': 'Extramedullary plasmacytoma in remission'
                },
                {
                  'code': 'C9022',
                  'description': 'Extramedullary plasmacytoma in relapse'
                },
                {
                  'code': 'C9030',
                  'description':
                      'Solitary plasmacytoma not having achieved remission'
                },
                {
                  'code': 'C9031',
                  'description': 'Solitary plasmacytoma in remission'
                },
                {
                  'code': 'C9032',
                  'description': 'Solitary plasmacytoma in relapse'
                },
                {
                  'code': 'E099',
                  'description':
                      'Drug or chemical induced diabetes mellitus without complications'
                },
              ]
            },
          ]
        },
      ]
    },
    {
      'title': 'EYE DISEASE GROUP',
      'sections': [
        {
          'title':
              'HCC298 - Severe Diabetic Eye Disease, Retinal Vein Occlusion, and Vitreous Hemorrhage',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'E08311',
                  'description':
                      'Diabetes mellitus due to underlying condition with unspecified diabetic retinopathy with macular edema'
                },
                {
                  'code': 'E083211',
                  'description':
                      'Diabetes mellitus due to underlying condition with mild nonproliferative diabetic retinopathy with macular edema, right eye'
                },
                {
                  'code': 'E083212',
                  'description':
                      'Diabetes mellitus due to underlying condition with mild nonproliferative diabetic retinopathy with macular edema, left eye'
                },
                {
                  'code': 'E083213',
                  'description':
                      'Diabetes mellitus due to underlying condition with mild nonproliferative diabetic retinopathy with macular edema, bilateral'
                },
                {
                  'code': 'E083219',
                  'description':
                      'Diabetes mellitus due to underlying condition with mild nonproliferative diabetic retinopathy with macular edema, unspecified eye'
                },
                {
                  'code': 'E083311',
                  'description':
                      'Diabetes mellitus due to underlying condition with moderate nonproliferative diabetic retinopathy with macular edema, right eye'
                },
                {
                  'code': 'E083312',
                  'description':
                      'Diabetes mellitus due to underlying condition with moderate nonproliferative diabetic retinopathy with macular edema, left eye'
                },
                {
                  'code': 'E083313',
                  'description':
                      'Diabetes mellitus due to underlying condition with moderate nonproliferative diabetic retinopathy with macular edema, bilateral'
                },
                {
                  'code': 'E083319',
                  'description':
                      'Diabetes mellitus due to underlying condition with moderate nonproliferative diabetic retinopathy with macular edema, unspecified eye'
                },
                {
                  'code': 'E083411',
                  'description':
                      'Diabetes mellitus due to underlying condition with severe nonproliferative diabetic retinopathy with macular edema, right eye'
                },
                {
                  'code': 'E083412',
                  'description':
                      'Diabetes mellitus due to underlying condition with severe nonproliferative diabetic retinopathy with macular edema, left eye'
                },
                {
                  'code': 'E083413',
                  'description':
                      'Diabetes mellitus due to underlying condition with severe nonproliferative diabetic retinopathy with macular edema, bilateral'
                },
                {
                  'code': 'E083419',
                  'description':
                      'Diabetes mellitus due to underlying condition with severe nonproliferative diabetic retinopathy with macular edema, unspecified eye'
                },
                {
                  'code': 'E083511',
                  'description':
                      'Diabetes mellitus due to underlying condition with proliferative diabetic retinopathy with macular edema, right eye'
                },
                {
                  'code': 'E083512',
                  'description':
                      'Diabetes mellitus due to underlying condition with proliferative diabetic retinopathy with macular edema, left eye'
                },
                {
                  'code': 'E083513',
                  'description':
                      'Diabetes mellitus due to underlying condition with proliferative diabetic retinopathy with macular edema, bilateral'
                },
                {
                  'code': 'E083519',
                  'description':
                      'Diabetes mellitus due to underlying condition with proliferative diabetic retinopathy with macular edema, unspecified eye'
                },
                {
                  'code': 'E083521',
                  'description':
                      'Diabetes mellitus due to underlying condition with proliferative diabetic retinopathy with traction retinal detachment involving the macula, right eye'
                },
                {
                  'code': 'E083522',
                  'description':
                      'Diabetes mellitus due to underlying condition with proliferative diabetic retinopathy with traction retinal detachment involving the macula, left eye'
                },
                {
                  'code': 'E083523',
                  'description':
                      'Diabetes mellitus due to underlying condition with proliferative diabetic retinopathy with traction retinal detachment involving the macula, bilateral'
                },
                {
                  'code': 'E083529',
                  'description':
                      'Diabetes mellitus due to underlying condition with proliferative diabetic retinopathy with traction retinal detachment involving the macula, unspecified eye'
                },
                {
                  'code': 'E083531',
                  'description':
                      'Diabetes mellitus due to underlying condition with proliferative diabetic retinopathy with traction retinal detachment not involving the macula, right eye'
                },
                {
                  'code': 'E083532',
                  'description':
                      'Diabetes mellitus due to underlying condition with proliferative diabetic retinopathy with traction retinal detachment not involving the macula, left eye'
                },
                {
                  'code': 'E083533',
                  'description':
                      'Diabetes mellitus due to underlying condition with proliferative diabetic retinopathy with traction retinal detachment not involving the macula, bilateral'
                },
                {
                  'code': 'E083539',
                  'description':
                      'Diabetes mellitus due to underlying condition with proliferative diabetic retinopathy with traction retinal detachment not involving the macula, unspecified eye'
                },
                {
                  'code': 'E083541',
                  'description':
                      'Diabetes mellitus due to underlying condition with proliferative diabetic retinopathy with combined traction retinal detachment and rhegmatogenous retinal detachment, right eye'
                },
                {
                  'code': 'E083542',
                  'description':
                      'Diabetes mellitus due to underlying condition with proliferative diabetic retinopathy with combined traction retinal detachment and rhegmatogenous retinal detachment, left eye'
                },
                {
                  'code': 'E083543',
                  'description':
                      'Diabetes mellitus due to underlying condition with proliferative diabetic retinopathy with combined traction retinal detachment and rhegmatogenous retinal detachment, bilateral'
                },
                {
                  'code': 'E083549',
                  'description':
                      'Diabetes mellitus due to underlying condition with proliferative diabetic retinopathy with combined traction retinal detachment and rhegmatogenous retinal detachment, unspecified eye'
                },
                {
                  'code': 'E083551',
                  'description':
                      'Diabetes mellitus due to underlying condition with stable proliferative diabetic retinopathy, right eye'
                },
                {
                  'code': 'E083552',
                  'description':
                      'Diabetes mellitus due to underlying condition with stable proliferative diabetic retinopathy, left eye'
                },
                {
                  'code': 'E083553',
                  'description':
                      'Diabetes mellitus due to underlying condition with stable proliferative diabetic retinopathy, bilateral'
                },
                {
                  'code': 'E083559',
                  'description':
                      'Diabetes mellitus due to underlying condition with stable proliferative diabetic retinopathy, unspecified eye'
                },
                {
                  'code': 'E083591',
                  'description':
                      'Diabetes mellitus due to underlying condition with proliferative diabetic retinopathy without macular edema, right eye'
                },
                {
                  'code': 'E083592',
                  'description':
                      'Diabetes mellitus due to underlying condition with proliferative diabetic retinopathy without macular edema, left eye'
                },
                {
                  'code': 'E083593',
                  'description':
                      'Diabetes mellitus due to underlying condition with proliferative diabetic retinopathy without macular edema, bilateral'
                },
                {
                  'code': 'E083599',
                  'description':
                      'Diabetes mellitus due to underlying condition with proliferative diabetic retinopathy without macular edema, unspecified eye'
                },
              ]
            },
          ]
        },
        {
          'title': 'HCC300 - Exudative Macular Degeneration',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'H353210',
                  'description':
                      'Exudative age-related macular degeneration, right eye, stage unspecified'
                },
                {
                  'code': 'H353211',
                  'description':
                      'Exudative age-related macular degeneration, right eye, with active choroidal neovascularization'
                },
                {
                  'code': 'H353212',
                  'description':
                      'Exudative age-related macular degeneration, right eye, with inactive choroidal neovascularization'
                },
                {
                  'code': 'H353213',
                  'description':
                      'Exudative age-related macular degeneration, right eye, with inactive scar'
                },
                {
                  'code': 'H353220',
                  'description':
                      'Exudative age-related macular degeneration, left eye, stage unspecified'
                },
                {
                  'code': 'H353221',
                  'description':
                      'Exudative age-related macular degeneration, left eye, with active choroidal neovascularization'
                },
                {
                  'code': 'H353222',
                  'description':
                      'Exudative age-related macular degeneration, left eye, with inactive choroidal neovascularization'
                },
                {
                  'code': 'H353223',
                  'description':
                      'Exudative age-related macular degeneration, left eye, with inactive scar'
                },
                {
                  'code': 'H353230',
                  'description':
                      'Exudative age-related macular degeneration, bilateral, stage unspecified'
                },
                {
                  'code': 'H353231',
                  'description':
                      'Exudative age-related macular degeneration, bilateral, with active choroidal neovascularization'
                },
                {
                  'code': 'H353232',
                  'description':
                      'Exudative age-related macular degeneration, bilateral, with inactive choroidal neovascularization'
                },
                {
                  'code': 'H353233',
                  'description':
                      'Exudative age-related macular degeneration, bilateral, with inactive scar'
                },
                {
                  'code': 'H353290',
                  'description':
                      'Exudative age-related macular degeneration, unspecified eye, stage unspecified'
                },
                {
                  'code': 'H353291',
                  'description':
                      'Exudative age-related macular degeneration, unspecified eye, with active choroidal neovascularization'
                },
                {
                  'code': 'H353292',
                  'description':
                      'Exudative age-related macular degeneration, unspecified eye, with inactive choroidal neovascularization'
                },
                {
                  'code': 'H353293',
                  'description':
                      'Exudative age-related macular degeneration, unspecified eye, with inactive scar'
                },
              ]
            },
          ]
        },
        {
          'title':
              'HCC122 - Proliferative Diabetic Retinopathy and Vitreous Hemorrhage',
          'subsections': [
            {
              'title': 'Document Results',
              'items': [
                {
                  'code': 'E093511',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with macular edema, right eye'
                },
                {
                  'code': 'E093512',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with macular edema, left eye'
                },
                {
                  'code': 'E093513',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with macular edema, bilateral'
                },
                {
                  'code': 'E093519',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with macular edema, unspecified eye'
                },
                {
                  'code': 'E093521',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with traction retinal detachment involving the macula, right eye'
                },
                {
                  'code': 'E093522',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with traction retinal detachment involving the macula, left eye'
                },
                {
                  'code': 'E093523',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with traction retinal detachment involving the macula, bilateral'
                },
                {
                  'code': 'E093529',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with traction retinal detachment involving the macula, unspecified eye'
                },
                {
                  'code': 'E093531',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with traction retinal detachment not involving the macula, right eye'
                },
                {
                  'code': 'E093532',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with traction retinal detachment not involving the macula, left eye'
                },
                {
                  'code': 'E093533',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with traction retinal detachment not involving the macula, bilateral'
                },
                {
                  'code': 'E093539',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with traction retinal detachment not involving the macula, unspecified eye'
                },
                {
                  'code': 'E093541',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with combined traction retinal detachment and rhegmatogenous retinal detachment, right eye'
                },
                {
                  'code': 'E093542',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with combined traction retinal detachment and rhegmatogenous retinal detachment, left eye'
                },
                {
                  'code': 'E093543',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with combined traction retinal detachment and rhegmatogenous retinal detachment, bilateral'
                },
                {
                  'code': 'E093549',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy with combined traction retinal detachment and rhegmatogenous retinal detachment, unspecified eye'
                },
                {
                  'code': 'E093551',
                  'description':
                      'Drug or chemical induced diabetes mellitus with stable proliferative diabetic retinopathy, right eye'
                },
                {
                  'code': 'E093552',
                  'description':
                      'Drug or chemical induced diabetes mellitus with stable proliferative diabetic retinopathy, left eye'
                },
                {
                  'code': 'E093553',
                  'description':
                      'Drug or chemical induced diabetes mellitus with stable proliferative diabetic retinopathy, bilateral'
                },
                {
                  'code': 'E093559',
                  'description':
                      'Drug or chemical induced diabetes mellitus with stable proliferative diabetic retinopathy, unspecified eye'
                },
                {
                  'code': 'E093591',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy without macular edema, right eye'
                },
                {
                  'code': 'E093592',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy without macular edema, left eye'
                },
                {
                  'code': 'E093593',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy without macular edema, bilateral'
                },
                {
                  'code': 'E093599',
                  'description':
                      'Drug or chemical induced diabetes mellitus with proliferative diabetic retinopathy without macular edema, unspecified eye'
                },
              ]
            },
          ]
        },
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Header
              AppHeaderWidget(
                onMenuPressed: () {
                  setState(() {
                    _isDrawerOpen = !_isDrawerOpen;
                  });
                },
                onProfileAction: (action) {
                  // Handle profile action
                },
              ),

              // Page content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 24.0),
                  child: Column(
                    children: [
                      // Page title
                      const Text(
                        'Pocket Guides',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF333333),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      // Resources container
                      Container(
                        constraints: const BoxConstraints(maxWidth: 800),
                        width: double.infinity,
                        child: Column(
                          children: [
                            // Quality Card
                            _buildResourceCard(
                              title: 'Quality',
                              isExpanded: _isQualityExpanded,
                              searchQuery: _qualitySearchQuery,
                              items: _qualityItems,
                              onToggle: () {
                                setState(() {
                                  _isQualityExpanded = !_isQualityExpanded;
                                });
                              },
                              onSearchChanged: (query) {
                                setState(() {
                                  _qualitySearchQuery = query;
                                });
                              },
                            ),

                            const SizedBox(height: 20),

                            // Risk Adjustments Card
                            _buildResourceCard(
                              title: 'Risk Adjustments',
                              isExpanded: _isRiskExpanded,
                              searchQuery: _riskSearchQuery,
                              items: _riskItems,
                              onToggle: () {
                                setState(() {
                                  _isRiskExpanded = !_isRiskExpanded;
                                });
                              },
                              onSearchChanged: (query) {
                                setState(() {
                                  _riskSearchQuery = query;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Navigation drawer
          AppDrawerWidget(
            isOpen: _isDrawerOpen,
            onClose: () {
              setState(() {
                _isDrawerOpen = false;
              });
            },
            onNavigation: (route) {
              setState(() {
                _isDrawerOpen = false;
              });
              _handleNavigation(route);
            },
            activeRoute: 'resources',
          ),

          // Logout dialog
          if (_showLogoutDialog) _buildLogoutDialog(),
        ],
      ),
    );
  }

  void _handleNavigation(String route) {
    switch (route) {
      case 'dashboard':
        Get.offAllNamed(RouteHelper.getDashboardRoute());
        break;
      case 'quality':
        Get.offAllNamed(RouteHelper.getQualityScoreCardsRoute());
        break;
      case 'schedule':
        Get.offAllNamed(RouteHelper.getScheduleRoute());
        break;
      case 'patients':
        Get.offAllNamed(RouteHelper.getPatientsRoute());
        break;
      case 'reports':
        Get.offAllNamed(RouteHelper.getReportsRoute());
        break;
      case 'resources':
        break;
      case 'settings':
        Get.offAllNamed(RouteHelper.getSettingsRoute());
        break;
      case 'logout':
        setState(() {
          _showLogoutDialog = true;
        });
        break;
    }
  }

  Widget _buildResourceCard({
    required String title,
    required bool isExpanded,
    required String searchQuery,
    required List<Map<String, dynamic>> items,
    required VoidCallback onToggle,
    required Function(String) onSearchChanged,
  }) {
    // Filter items based on search query
    final filteredItems = items.where((item) {
      if (searchQuery.isEmpty) return true;
      return item['title'].toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card header
          InkWell(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                border: Border(
                  bottom: BorderSide(color: const Color(0xFFE0E0E0)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: const Color(0xFF666666),
                  ),
                ],
              ),
            ),
          ),

          // Card content
          if (isExpanded)
            Column(
              children: [
                // Search container
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFF0F0F0)),
                    ),
                  ),
                  child: TextField(
                    onChanged: onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: const TextStyle(color: Color(0xFF666666)),
                      prefixIcon:
                          const Icon(Icons.search, color: Color(0xFF666666)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFF1976D2)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),

                // Items list
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: filteredItems
                        .map((item) => _buildExpandableItem(item))
                        .toList(),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildExpandableItem(Map<String, dynamic> item) {
    return _ExpandableItemWidget(item: item);
  }

  Widget _buildLogoutDialog() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 60,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDC3545),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),

              // Body
              Container(
                padding: const EdgeInsets.all(24),
                child: const Column(
                  children: [
                    Text(
                      'Are you sure you want to log out of your account?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF333333),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "You'll need to sign in again to access your dashboard.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _showLogoutDialog = false;
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                          backgroundColor: const Color(0xFFF8F9FA),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle logout
                          context.go('/login');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: const Color(0xFFDC3545),
                        ),
                        child: const Text(
                          'Log Out',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpandableItemWidget extends StatefulWidget {
  final Map<String, dynamic> item;

  const _ExpandableItemWidget({required this.item});

  @override
  State<_ExpandableItemWidget> createState() => _ExpandableItemWidgetState();
}

class _ExpandableItemWidgetState extends State<_ExpandableItemWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          // Item header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.item['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),

          // Item content
          if (_isExpanded)
            Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: widget.item['sections'].map<Widget>((section) {
                  return Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xFF1976D2), width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                        // Section header
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1976D2),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  section['title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Section content
                        Container(
                          padding: const EdgeInsets.all(16),
                          constraints: const BoxConstraints(maxHeight: 400),
                          width: double.infinity,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _buildSectionContent(section),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildSectionContent(Map<String, dynamic> section) {
    // Check if this section has subsections (new structure)
    if (section.containsKey('subsections')) {
      return section['subsections'].map<Widget>((subsection) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subsection title (h4 equivalent)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                subsection['title'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            // Subsection items
            ...subsection['items'].map<Widget>((item) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Code row - can wrap if needed
                    Container(
                      width: double.infinity,
                      child: Text(
                        item['code'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1976D2),
                          fontFamily: 'Courier New',
                          fontSize: 12,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Description row
                    Container(
                      width: double.infinity,
                      child: Text(
                        item['description'],
                        style: const TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 13,
                          height: 1.4,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        );
      }).toList();
    } else {
      // Old structure - direct items
      return section['items'].map<Widget>((item) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFFE0E0E0)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Code row - can wrap if needed
              Container(
                width: double.infinity,
                child: Text(
                  item['code'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1976D2),
                    fontFamily: 'Courier New',
                    fontSize: 12,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
              const SizedBox(height: 4),
              // Description row
              Container(
                width: double.infinity,
                child: Text(
                  item['description'],
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 13,
                    height: 1.4,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
        );
      }).toList();
    }
  }
}
