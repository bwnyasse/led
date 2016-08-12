package fr.bwnyasse.api;

import java.util.List;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import fr.bwnyasse.domain.Article;
import fr.bwnyasse.service.ArticleService;

@ApplicationScoped
@Path("/_api")
public class RsController {

	@Inject
	private ArticleService postService;

	@GET
	@Produces(MediaType.APPLICATION_JSON)
	@Path("/articles")
	public List<Article> findAll() {
		return postService.findAll();
	}
}
