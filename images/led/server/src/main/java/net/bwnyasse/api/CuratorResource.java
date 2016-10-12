package net.bwnyasse.api;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@ApplicationScoped
@Path("/curator")
public class CuratorResource {

	private static String CURATOR_COMMAND = "/bin/sh /curator.sh";

	@Inject
	private ExecuteShellComand shellCommand;

	@GET
	@Produces(MediaType.TEXT_PLAIN)
	public String apply() throws Exception {
		return shellCommand.executeCommand(CURATOR_COMMAND);
	}
}
