package com.example.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.vo.HomeVO;

import lombok.extern.java.Log;

@Repository("homeDao")
public class HomeDaoImpl implements HomeDao {
	@Autowired
	private SqlSession sqlSession;


	@Override
	public List<HomeVO> selectAllHome() {
		return this.sqlSession.selectList("Home.selectAll");
	}

	@Override
	public int getTotolCount() {
		return (Integer)this.sqlSession.selectOne("Home.selectCount");
	}


}
