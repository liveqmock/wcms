package com.kiy.wcms.procurementplan.entity;

import java.util.Date;

import com.kiy.wcms.sys.entity.SysUser;

/**
 * 采购计划
 * @author wuwenlong
 * @date 2014年9月20日
 */
public class ProcurementPlan {
	/**
	 * 主键
	 */
	private int id;
	/**
	 * 采购计划编号
	 */
	private String code;
	/**
	 * 提报人
	 */
	private String applyUser;
	/**
	 * 提报人名称
	 */
	private String applyUserName;
	/**
	 * 提报日期
	 */
	private String applyDate;
	/**
	 * 创建人
	 */
	private SysUser createUser;
	/**
	 * 创建日期
	 */
	private Date createDate;
	/**
	 * 状态
	 */
	private int status;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getApplyUser() {
		return applyUser;
	}
	public void setApplyUser(String applyUser) {
		this.applyUser = applyUser;
	}
	public String getApplyDate() {
		return applyDate;
	}
	public void setApplyDate(String applyDate) {
		this.applyDate = applyDate;
	}
	public SysUser getCreateUser() {
		return createUser;
	}
	public void setCreateUser(SysUser createUser) {
		this.createUser = createUser;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public String getApplyUserName() {
		return applyUserName;
	}
	public void setApplyUserName(String applyUserName) {
		this.applyUserName = applyUserName;
	}
	
}
