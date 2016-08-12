package fr.bwnyasse.domain;

import java.io.Serializable;

import lombok.Data;

@Data
public class Article implements Serializable {

	private static final long serialVersionUID = 1L;

	private String id;
	private String title;
	private String subTitle;
	private String postedBy;
	private String date;
	private String contentAsHtml;
	private String contentMarkdownPath;

}
