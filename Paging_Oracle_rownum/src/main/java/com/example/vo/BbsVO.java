package com.example.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class BbsVO {
	//Member
	private int idx;
	private String writer;
	private String contents;
	private String title;
	private String email;
	private int readnum;
	private String writeday;
	
}
