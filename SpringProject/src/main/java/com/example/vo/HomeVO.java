package com.example.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class HomeVO {
	private int bno;
	private String title;
	private String content;
	private String email;
	private String regdate;
	private int readnum;
	private String writer;
	private int grp;
	private int lvl;
	private int step;
}
