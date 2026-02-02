package com.ketter.backend;

import ca.uhn.fhir.rest.annotation.Create;
import ca.uhn.fhir.rest.annotation.IdParam;
import ca.uhn.fhir.rest.annotation.Read;
import ca.uhn.fhir.rest.annotation.ResourceParam;
import ca.uhn.fhir.rest.api.MethodOutcome;
import ca.uhn.fhir.rest.server.IResourceProvider;
import org.hl7.fhir.instance.model.api.IBaseResource;
import org.hl7.fhir.r4.model.IdType;
import org.hl7.fhir.r4.model.Patient;

import java.util.HashMap;
import java.util.Map;

public class PatientResourceProvider implements IResourceProvider {

    private final Map<String, Patient> patientMap = new HashMap<>();

    @Override
    public Class<? extends IBaseResource> getResourceType() {
        return Patient.class;
    }

    @Read()
    public Patient read(@IdParam IdType theId) {
        return patientMap.get(theId.getIdPart());
    }

    @Create()
    public MethodOutcome create(@ResourceParam Patient thePatient) {
        String id = thePatient.getIdElement().getIdPart();
        if (id == null || id.isEmpty()) {
            id = String.valueOf(patientMap.size() + 1);
            thePatient.setId(new IdType(id));
        }
        patientMap.put(id, thePatient);
        return new MethodOutcome(new IdType("Patient", id));
    }
}
