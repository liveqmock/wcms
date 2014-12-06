package com.kiy.wcms.design.entity;

public class DesignAtta {
	private int id;
	private int designId;
	private String filePath;
	private String fileName;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getDesignId() {
		return designId;
	}
	public void setDesignId(int designId) {
		this.designId = designId;
	}
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
}
