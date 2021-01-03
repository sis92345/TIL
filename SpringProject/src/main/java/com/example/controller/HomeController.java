package com.example.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.service.HomeService;
import com.example.vo.HomeVO;

import lombok.extern.java.Log;

@Controller
@Log
public class HomeController {
	@Autowired
	private HomeService homeService;
	
	@GetMapping(value="/")
	public String list(Model model, @RequestParam("page") String pageStr) {
		int pageSize = 10; //한 페이지에 뿌려지는 레코드의 수: 임의
		int totalPage = this.homeService.getTotalPage(pageSize); //전체 페이지 수
		int page = (pageStr == null) ? 1:Integer.parseInt(pageStr);
		List<HomeVO> list = this.homeService.readAll();
		log.info("현재 페이지: " + page);
		log.info("페이지 사이즈: " + pageSize);
		log.info("전체페이지: " + totalPage);
		model.addAttribute("qnaList", list);
		model.addAttribute("currentPage", page);	//현재 페이지
		model.addAttribute("pageSize", pageSize);	//페이지 레코드 수
		model.addAttribute("totalPage", totalPage);	//전체 페이지
		return "/list";
	}
	
}