package net.bwnyasse.domain;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.databind.ObjectMapper;

public class Json {

	public static void main(String[] args) throws Exception {
		GlobalConfiguration global = new GlobalConfiguration();

		List<Level> levels = new ArrayList<>();

		Level l1 = new Level();
		l1.setName("ERROR");
		l1.setPattern("ERROR");
		l1.setColor("#D9534F");
		levels.add(l1);

		l1 = new Level();
		l1.setName("INFO");
		l1.setPattern("INFO");
		l1.setColor("#5BC0DE");
		levels.add(l1);

		global.setLevels(levels);

		ObjectMapper mapper = new ObjectMapper();

		// Object to JSON in String
		String jsonInString = mapper.writeValueAsString(global);

		System.out.println(jsonInString);

	}
}
