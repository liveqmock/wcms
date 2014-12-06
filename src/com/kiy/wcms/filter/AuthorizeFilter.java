package com.kiy.wcms.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.kiy.wcms.Global;
import com.kiy.wcms.sys.entity.SysUser;





public class AuthorizeFilter implements Filter{
	/**
	 * Filter
	 * @param config FilterConfig
	 * @throws ServletException
	 */
	public void init(FilterConfig config) throws ServletException {
	}
	
	/**
	 * 
	 */
	public void destroy() {
	}
	
	/**
	 * 
	 * @param request ServletRequest
	 * @param response ServletResponse
	 * @param chain FilterChain
	 * @throws IOException
	 * @throws ServletException
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;
		
		SysUser user =  (SysUser)req.getSession().getAttribute(Global.LOGIN_USER);
		String uri = req.getRequestURI();
		
		if(!(uri.startsWith(req.getContextPath() + "/img/") || uri.startsWith(req.getContextPath() + "/css/") 
				|| uri.startsWith(req.getContextPath() + "/js/") || uri.endsWith(".jpg"))){
			if (user==null && !(uri.equals(req.getContextPath()+"/login/login") || uri.equals(req.getContextPath() + "/login/checkAuthCode")
					|| uri.equals(req.getContextPath()+ "/index.jsp"))) {
				res.sendRedirect(req.getContextPath()+"/index.jsp");
				return;
			}
		}
		chain.doFilter(req, response);
	}
}
