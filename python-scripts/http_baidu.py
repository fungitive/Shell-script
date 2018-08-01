#!/usr/bin/env python
# -*- coding:utf-8 -*-
# Author:Wangj
# 1. 打开浏览器，访问p.to

driver = webdriver.Chrome()
def openDriver():
    driver.get("http://p.to")
    driver.maximize_window()