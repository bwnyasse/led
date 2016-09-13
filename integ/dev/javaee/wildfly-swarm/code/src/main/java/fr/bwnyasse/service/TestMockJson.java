package fr.bwnyasse.service;

import java.io.InputStream;
import java.util.List;

import org.apache.commons.io.IOUtils;

import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;

import fr.bwnyasse.domain.Article;

public class TestMockJson {

	public static void main(String[] args) throws Exception {

		ObjectMapper mapper = new ObjectMapper();

		String finalName = "MOCK_DATA.json";

		InputStream jsonAsStream = Thread.currentThread().getContextClassLoader().getResourceAsStream(finalName);

		String jsonString = IOUtils.toString(jsonAsStream, "UTF-8");

		Class<?> clz = Class.forName(Article.class.getName());
		JavaType type = mapper.getTypeFactory().constructCollectionType(List.class, clz);
		List<Article> postList = mapper.readValue(jsonString, type);
		System.out.println(postList.size());
	}
}
