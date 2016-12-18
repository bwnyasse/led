package net.bwnyasse.api;

import java.io.File;
import java.io.IOException;

import javax.enterprise.context.ApplicationScoped;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import com.fasterxml.jackson.databind.ObjectMapper;

import net.bwnyasse.domain.GlobalConfiguration;

@ApplicationScoped
@Path("/configuration")
public class ConfigurationResource {

	private static String DIR = "/opt/led/conf/";

	private static String DEFAULT_CONF_FILE = "config-default.json";
	private static String CONF_FILE = "config.json";

	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public GlobalConfiguration config() throws Exception {
		File file = new File(DIR, CONF_FILE);
		if (!file.exists()) {
			file = new File(DIR, DEFAULT_CONF_FILE);
		}
		return new ObjectMapper().readValue(file, GlobalConfiguration.class);
	}

	@POST
	@Produces(MediaType.APPLICATION_JSON)
	@Consumes(MediaType.APPLICATION_JSON)
	public GlobalConfiguration update(GlobalConfiguration configuration) throws IOException {
		ObjectMapper mapper = new ObjectMapper();

		// Object to JSON in file
		mapper.writeValue(new File(DIR, CONF_FILE), configuration);

		return configuration;
	}
}
