package com.kiy.wcms.procurementplan.entity;
/**
 * 采购计划附件
 * @author wuwenlong
 * @date 2014年9月28日
 */
public class ProcurementAtta {
	/**
	 * 主键
	 */
	private int id;
	/**
	 * 采购计划主键
	 */
	private int planId;
	/**
	 * 附件路径
	 */
	private String attaPath;
	
	private String fileName;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getPlanId() {
		return planId;
	}
	public void setPlanId(int planId) {
		this.planId = planId;
	}
	public String getAttaPath() {
		return attaPath;
	}
	public void setAttaPath(String attaPath) {
		this.attaPath = attaPath;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
}
