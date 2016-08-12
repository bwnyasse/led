package fr.bwnyasse.service;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import javax.enterprise.context.ApplicationScoped;

import org.apache.commons.io.IOUtils;

import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;

import fr.bwnyasse.domain.Article;

@ApplicationScoped
public class ArticleService {

	public List<Article> findAll() {
		try {
			return getMocks();
		} catch (Exception e) {
			e.printStackTrace();
			return new ArrayList<>();
		}
	}

	public Article getArticleById(String id) {
		return findAll().stream().filter(article -> article.getId().equalsIgnoreCase(id)).findFirst().get();
	}

	public void addArticle(Article article) {
		System.out.println(article.toString());
	}

	public void updateArticle(Article article) {
		System.out.println(article.toString());
	}

	private static List<Article> getMocks() throws Exception {
		ObjectMapper mapper = new ObjectMapper();

		String finalName = "MOCK_DATA.json";

		InputStream jsonAsStream = Thread.currentThread().getContextClassLoader().getResourceAsStream(finalName);

		String jsonString = IOUtils.toString(jsonAsStream, "UTF-8");

		Class<?> clz = Class.forName(Article.class.getName());
		JavaType type = mapper.getTypeFactory().constructCollectionType(List.class, clz);
		return mapper.readValue(jsonString, type);
	}
}
