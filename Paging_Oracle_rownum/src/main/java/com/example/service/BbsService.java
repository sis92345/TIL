package com.example.service;

import java.util.List;
import java.util.Map;

import com.example.vo.BbsVO;

public interface BbsService {
	List<BbsVO> selectAll(Map<String, Object> map);
	int getTotolCount();
}
