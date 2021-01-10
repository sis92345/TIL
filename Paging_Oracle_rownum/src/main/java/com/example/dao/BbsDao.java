package com.example.dao;

import java.util.List;
import java.util.Map;

import com.example.vo.BbsVO;

public interface BbsDao {
	List<BbsVO> selectAll(Map<String, Object> map);
	int getTotolCount();
}
