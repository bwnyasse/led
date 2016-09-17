package net.bwnyasse.domain;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.databind.ObjectMapper;

public class Json {

	public static void main(String[] args) throws Exception {
		GlobalConfiguration global = new GlobalConfiguration();

		List<LevelConfiguration> levels = new ArrayList<>();
		List<LevelConfiguration> levelsLog = new ArrayList<>();

		LevelConfiguration l1 = new LevelConfiguration();
		l1.setName("ERROR");
		l1.setPattern("ERROR");
		l1.setColor("#D9534F");
		levels.add(l1);
		levelsLog.add(l1);

		l1 = new LevelConfiguration();
		l1.setName("INFO");
		l1.setPattern("INFO");
		l1.setColor("#5BC0DE");
		levels.add(l1);

		global.setLevelsConfiguration(levelsLog);
		global.setLevelsLogMessageConfiguration(levelsLog);

		ObjectMapper mapper = new ObjectMapper();

		// Object to JSON in String
		String jsonInString = mapper.writeValueAsString(global);

		System.out.println(jsonInString);

	}
}
