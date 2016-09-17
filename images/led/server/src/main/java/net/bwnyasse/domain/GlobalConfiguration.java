package net.bwnyasse.domain;

import java.util.List;

import lombok.Data;

@Data
public class GlobalConfiguration {

	private List<LevelConfiguration> levelsConfiguration;

	private List<LevelConfiguration> levelsLogMessageConfiguration;

}
