package com.example.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.dao.BbsDao;
import com.example.vo.BbsVO;

@Service
public class BbsServiceImpl implements BbsService{
	@Autowired
	private BbsDao bbsDao;
	@Override
	public List<BbsVO> selectAll(Map<String, Object> map) {
		return this.bbsDao.selectAll(map);
	}
	@Override
	public int getTotolCount() {
		return this.bbsDao.getTotolCount();
	}
}
