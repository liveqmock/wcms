package com.kiy.wcms.exception;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;

public class KiyExceptionHandler implements HandlerExceptionResolver{
	private Logger logger = Logger.getLogger(this.getClass());
	public ModelAndView resolveException(HttpServletRequest request,
			HttpServletResponse response, Object obj, Exception e) {
		logger.error("访问" + request.getRequestURI() + "出现异常" +
			"异常信息：" + e.getMessage());
		e.printStackTrace();
		StackTraceElement[] es = e.getStackTrace();
		if(es != null){
			for(StackTraceElement element : es){
				logger.error(element.toString());
			}
		}
		ModelAndView view = new ModelAndView("/error/error");
		return view;
	}

}
