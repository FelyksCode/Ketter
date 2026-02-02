package com.ketter.backend;

import ca.uhn.fhir.rest.annotation.Create;
import ca.uhn.fhir.rest.annotation.IdParam;
import ca.uhn.fhir.rest.annotation.Read;
import ca.uhn.fhir.rest.annotation.ResourceParam;
import ca.uhn.fhir.rest.api.MethodOutcome;
import ca.uhn.fhir.rest.server.IResourceProvider;
import org.hl7.fhir.instance.model.api.IBaseResource;
import org.hl7.fhir.r4.model.IdType;
import org.hl7.fhir.r4.model.Observation;

import java.util.HashMap;
import java.util.Map;

public class ObservationResourceProvider implements IResourceProvider {

    private final Map<String, Observation> observationMap = new HashMap<>();

    @Override
    public Class<? extends IBaseResource> getResourceType() {
        return Observation.class;
    }

    @Read()
    public Observation read(@IdParam IdType theId) {
        return observationMap.get(theId.getIdPart());
    }

    @Create()
    public MethodOutcome create(@ResourceParam Observation theObservation) {
        String id = theObservation.getIdElement().getIdPart();
        if (id == null || id.isEmpty()) {
            id = String.valueOf(observationMap.size() + 1);
            theObservation.setId(new IdType(id));
        }
        observationMap.put(id, theObservation);
        System.out.println("Stored Observation: " + id);
        return new MethodOutcome(new IdType("Observation", id));
    }
}
