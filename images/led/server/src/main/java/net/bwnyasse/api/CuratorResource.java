package net.bwnyasse.api;

import java.text.MessageFormat;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@ApplicationScoped
@Path("/curator")
public class CuratorResource {

	private static String CURATOR_COMMAND = "/bin/bash -c led_curator {0}";

	@Inject
	private ExecuteShellComand shellCommand;

	@GET
	@Path("{olderThan}")
	@Produces(MediaType.TEXT_PLAIN)
	public String apply(@PathParam("olderThan") String olderThan) throws Exception {
		return shellCommand.executeCommand(MessageFormat.format(CURATOR_COMMAND, olderThan));
	}
}
