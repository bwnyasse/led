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

	private static String GET_CURATOR_CRON_VALUE = "get_cron_curator_value.sh {0} {1}";

	@Inject
	private ExecuteShellComand shellCommand;

	@GET
	@Path("{perform}")
	@Produces(MediaType.TEXT_PLAIN)
	public String perform(@PathParam("olderThan") String olderThan) throws Exception {
		return shellCommand.executeCommand(MessageFormat.format(CURATOR_COMMAND, olderThan));
	}

	@GET
	@Path("{value}")
	@Produces(MediaType.TEXT_PLAIN)
	public String getKeyValue(@PathParam("key") String key, @PathParam("line") String line) throws Exception {
		return shellCommand.executeCommand(MessageFormat.format(GET_CURATOR_CRON_VALUE, key, line));
	}
}
