package com.example.dao;

import java.util.List;

import com.example.vo.HomeVO;


public interface HomeDao {
	
	List<HomeVO> selectAllHome();
	int getTotolCount();
}
