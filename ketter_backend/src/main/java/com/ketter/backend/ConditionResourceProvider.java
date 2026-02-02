package com.ketter.backend;

import ca.uhn.fhir.rest.annotation.Create;
import ca.uhn.fhir.rest.annotation.IdParam;
import ca.uhn.fhir.rest.annotation.Read;
import ca.uhn.fhir.rest.annotation.ResourceParam;
import ca.uhn.fhir.rest.api.MethodOutcome;
import ca.uhn.fhir.rest.server.IResourceProvider;
import org.hl7.fhir.instance.model.api.IBaseResource;
import org.hl7.fhir.r4.model.IdType;
import org.hl7.fhir.r4.model.Condition;

import java.util.HashMap;
import java.util.Map;

public class ConditionResourceProvider implements IResourceProvider {

    private final Map<String, Condition> conditionMap = new HashMap<>();

    @Override
    public Class<? extends IBaseResource> getResourceType() {
        return Condition.class;
    }

    @Read()
    public Condition read(@IdParam IdType theId) {
        return conditionMap.get(theId.getIdPart());
    }

    @Create()
    public MethodOutcome create(@ResourceParam Condition theCondition) {
        String id = String.valueOf(conditionMap.size() + 1);
        theCondition.setId(new IdType(id));
        conditionMap.put(id, theCondition);
        return new MethodOutcome(new IdType("Condition", id));
    }
}
