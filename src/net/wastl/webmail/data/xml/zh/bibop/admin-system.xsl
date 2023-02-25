<?xml version="1.0" encoding="UTF-8"?>
<!--
 * Copyright (C) 2000 Sebastian Schaffert
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
-->


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" indent="yes"/>

    <xsl:variable name="imgbase" select="/GENERICMODEL/STATEDATA/VAR[@name='img base uri']/@value"/>
    <xsl:variable name="base" select="/GENERICMODEL/STATEDATA/VAR[@name='base uri']/@value"/>
    <xsl:variable name="session-id" select="/GENERICMODEL/STATEDATA/VAR[@name='session id']/@value"/>
  
    <xsl:template match="/">

    <HTML>
      <HEAD>
        <TITLE>WebMail 管理介面：系統設定</TITLE>
	<META CONTENT="AUTHOR" VALUE="Sebastian Schaffert"/>
      </HEAD>
	
      <BODY BGCOLOR="white">
	<FORM ACTION="{$base}/admin/system/set?session-id={$session-id}" METHOD="POST">
	  <TABLE WIDTH="100%" CELLSPACING="0" CELLPADDING="0">
	    <xsl:for-each select="/GENERICMODEL/SYSDATA/GROUP">
	      <TR bgcolor="#dddddd">
		<TD COLSPAN="2" ALIGN="center"><FONT SIZE="+1"><STRONG>群組: <xsl:value-of select="@name"/></STRONG></FONT></TD>
	      </TR>
	      <xsl:for-each select="CONFIG">
		<xsl:sort select="KEY" order="ascending"/>
		<xsl:choose>
		  <xsl:when test="position() mod 2 = 1">
		    <TR bgcolor="#f7f3a8">
		      <xsl:call-template name="row"/>
		    </TR>
		  </xsl:when>
		  <xsl:otherwise>
		    <TR>
		      <xsl:call-template name="row"/>
		    </TR>
		  </xsl:otherwise>
		</xsl:choose>
	      </xsl:for-each>
	    </xsl:for-each>
	    <TR bgcolor="#dddddd">
	      <TD COLSPAN="2" ALIGN="center"><FONT SIZE="+1"><STRONG>表單</STRONG></FONT></TD>
	    </TR>
	    <TR>
	      <TD COLSPAN="2" ALIGN="center">
		<INPUT TYPE="submit" name="submit" value="啟動修改"/>
		<INPUT TYPE="reset" name="reset" value="取消修改"/>
	      </TD>
	    </TR>
	  </TABLE>
	</FORM>
      </BODY>
	
    </HTML>

  </xsl:template>

  <xsl:template name="row">
    <TD>
      <STRONG><xsl:value-of select="KEY"/></STRONG><BR/>
      <EM><xsl:apply-templates select="DESCRIPTION"/></EM>
    </TD>
    <TD>
      <xsl:choose>
	<xsl:when test="@type = 'choice'">
	  <SELECT name="{KEY}">
	    <xsl:for-each select="CHOICE">
	      <xsl:choose>
		<xsl:when test=". = ../VALUE">
		  <OPTION selected="selected"><xsl:value-of select="."/></OPTION>
		</xsl:when>
		<xsl:otherwise>
		  <OPTION><xsl:value-of select="."/></OPTION>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:for-each>
	  </SELECT>
	</xsl:when>
	<xsl:when test="@type = 'bool'">
	  <SELECT name="{KEY}">
	    <xsl:for-each select="CHOICE">
	      <xsl:choose>
		<xsl:when test=". = ../VALUE">
		  <OPTION selected="selected"><xsl:value-of select="."/></OPTION>
		</xsl:when>
		<xsl:otherwise>
		  <OPTION><xsl:value-of select="."/></OPTION>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:for-each>
	  </SELECT>
	</xsl:when>
	<xsl:when test="@type = 'int'">
	  <INPUT type="text" name="{KEY}" SIZE="6" value="{VALUE}"/>
	</xsl:when>
	<xsl:otherwise>
	  <INPUT type="text" name="{KEY}" SIZE="40" value="{VALUE}"/>
	</xsl:otherwise>
      </xsl:choose>
    </TD>
  </xsl:template>
</xsl:stylesheet>
