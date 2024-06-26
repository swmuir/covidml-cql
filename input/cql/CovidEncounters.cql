library CovidEncounters version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.1.000'
include FHIRCommon version '1.0.0' called FC
include USCoreFHIRElements version '1.0.0' called UE
include CovidConcepts called Cx
// include DataElementHelpers called DE

codesystem "ActCode": 'http://terminology.hl7.org/CodeSystem/v3-ActCode'

// Value sets for Encounter.type codes.
valueset "Emergency Department Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.292'
valueset "Encounter Inpatient": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.666.5.307'

valueset "Annual Wellness Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1240'
valueset "Face-to-Face Interaction": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1048'
valueset "Home Healthcare Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Outpatient Consultation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Telehealth Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1031'
valueset "Telephone Visits": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1080'

// Encounter.class codes
// http://hl7.org/fhir/R4/v3/ActEncounterCode/vs.html
code "ambulatory": 'AMB' from ActCode display 'ambulatory'
code "emergency": 'EMER' from ActCode display 'emergency'
code "field": 'FLD' from ActCode display 'field'
code "home health": 'HH' from ActCode display 'home health'
code "inpatient encounter": 'IMP' from ActCode display 'inpatient encounter'
code "inpatient acute": 'ACUTE' from ActCode display 'inpatient acute'
code "inpatient non-acute": 'NONAC' from ActCode display 'inpatient non-acute'
code "observation encounter": 'OBSENC' from ActCode display 'observation encounter'
code "pre-admission": 'PRENC' from ActCode display 'pre-admission'
code "short stay": 'SS' from ActCode display 'short stay'
code "virtual": 'VR' from ActCode display 'VR'

context Patient

define ReportEncounters: 
{
  "Outpatient Count": Count("Outpatient Encounters"),
  "Inpatient Count": Count("Inpatient Encounters"),
  "EmergencyDepartment Count": Count("Emergency Department Encounters"),
  "Encounters with Reason Count": Count("Encounters with Reason"),
  "All Count": Count("All Encounters")
}

define "Outpatient Encounters":
  [Encounter] enc
    where enc.class ~ "ambulatory"

define "Inpatient Encounters":
  [Encounter] enc
    where enc.class ~ "inpatient encounter"
      or enc.class ~ "inpatient acute"
      or enc.class ~ "inpatient non-acute"
      or enc.class ~ "short stay"

define "Emergency Department Encounters":
  [Encounter] enc
    where enc.class ~ "emergency"

define "Encounters with Reason":
  [Encounter] enc
    where enc.reasonCode is not null
    
define "All Encounters":
  ["Encounter"]

/*
  These expressions are not currently used, where Encounter is filtered by Encounter.type
*/
define "Outpatient Encounters Using Type":
  ["Encounter": "Office Visit"]
    union ["Encounter": "Outpatient Consultation"]
    union ["Encounter": "Annual Wellness Visit"]
    union ["Encounter": "Face-to-Face Interaction"]
    union ["Encounter": "Home Healthcare Services"]
    union ["Encounter": "Telehealth Services"]
    union ["Encounter": "Telephone Visits"]

define "Inpatient Encounters Using Type":
  ["Encounter": "Encounter Inpatient"] InpatientEncounter

define "Emergency Department Encounters Using Type":
  ["Encounter": "Emergency Department Visit"]
