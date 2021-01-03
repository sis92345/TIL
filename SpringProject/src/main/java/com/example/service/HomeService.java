package com.example.service;

import java.util.List;

import com.example.vo.HomeVO;

public interface HomeService {
	List<HomeVO> readAll();
	int getTotalPage(int pageSize);
}
