package com.kiy.wcms.procurementplan.entity;

import java.util.Date;

import com.kiy.wcms.sys.entity.SysUser;

/**
 * 采购计划查询参数
 * @author wuwenlong 
 * @date 2014年9月20日
 */

public class ProcurementPlanParam {
	/**
	 * 起始页标
	 */
	private int begin;
	/**
	 * 每页显示条数
	 */
	private int rows;
	
	private int seeStatus;
	private int auditStatus;
	/**
	 * 主键
	 */
	private Integer id;
	/**
	 * 采购编号
	 */
	private String code;
	
	/**
	 * 计划人编码
	 */
	private String applyUser;
	/**
	 * 提报日期
	 */
	private String applyDate;
	/**
	 * 计划日期起
	 */
	private String applyDateBegin;
	/**
	 * 计划日期止
	 */
	private String applyDateEnd;
	/**
	 * 计划人
	 */
	private String applyUserName;
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
	private Integer status;
	public int getBegin() {
		return begin;
	}
	public void setBegin(int begin) {
		this.begin = begin;
	}
	public int getRows() {
		return rows;
	}
	public void setRows(int rows) {
		this.rows = rows;
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
	public String getApplyDateBegin() {
		return applyDateBegin;
	}
	public void setApplyDateBegin(String applyDateBegin) {
		this.applyDateBegin = applyDateBegin;
	}
	public String getApplyDateEnd() {
		return applyDateEnd;
	}
	public void setApplyDateEnd(String applyDateEnd) {
		this.applyDateEnd = applyDateEnd;
	}
	public String getApplyUserName() {
		return applyUserName;
	}
	public void setApplyUserName(String applyUserName) {
		this.applyUserName = applyUserName;
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
	public String getApplyDate() {
		return applyDate;
	}
	public void setApplyDate(String applyDate) {
		this.applyDate = applyDate;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public int getSeeStatus() {
		return seeStatus;
	}
	public void setSeeStatus(int seeStatus) {
		this.seeStatus = seeStatus;
	}
	public int getAuditStatus() {
		return auditStatus;
	}
	public void setAuditStatus(int auditStatus) {
		this.auditStatus = auditStatus;
	}
}
