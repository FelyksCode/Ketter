package com.ketter.backend;

import ca.uhn.fhir.context.FhirContext;
import ca.uhn.fhir.rest.server.RestfulServer;
import ca.uhn.fhir.rest.server.interceptor.ResponseHighlighterInterceptor;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

@WebServlet(urlPatterns = {"/fhir/*"}, displayName = "Ketter FHIR Server")
public class FhirRestfulServer extends RestfulServer {

    @Override
    protected void initialize() throws ServletException {
        // Initialize the FHIR Context for R4
        setFhirContext(FhirContext.forR4());

        // Register resource providers
        // registerProvider(new PatientResourceProvider());
        // registerProvider(new ObservationResourceProvider());

        // Interceptor for pretty printing and syntax highlighting in the browser
        registerInterceptor(new ResponseHighlighterInterceptor());
    }
}
