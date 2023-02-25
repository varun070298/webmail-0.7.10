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
  
    <xsl:variable name="imgbase" select="/USERMODEL/STATEDATA/VAR[@name='img base uri']/@value"/>
    <xsl:variable name="base" select="/USERMODEL/STATEDATA/VAR[@name='base uri']/@value"/>
    <xsl:variable name="session-id" select="/USERMODEL/STATEDATA/VAR[@name='session id']/@value"/>

    <xsl:template match="/">

    <HTML>
      <HEAD>
        <TITLE> <xsl:value-of select="/USERMODEL/USERDATA/FULL_NAME"/> 的 WebMail 信箱：信箱清單</TITLE>
	<META CONTENT="AUTHOR" VALUE="Sebastian Schaffert"/>
	<link rel="stylesheet" href="{$base}/passthrough/webmail.css"/>
      </HEAD>
      
      <BODY bgcolor="#B5C1CF" topmargin="5" leftmargin="0" marginwidth="0" marginheight="5">
	<P class="testoChiaro">
	  <SPAN class="testoScuro">歡迎來到您的信箱，<xsl:value-of select="/USERMODEL/USERDATA/FULL_NAME"/>.</SPAN><BR/>
	  這是 <SPAN class="testoScuro">第<xsl:apply-templates select="/USERMODEL/USERDATA/INTVAR[@name='login count']"/>次</SPAN> 您登入到本系統，自從 <SPAN class="testoScuro"><xsl:apply-templates select="/USERMODEL/STATEDATA/VAR[@name='first login']"/></SPAN>。<BR/>
	  您<SPAN class="bold">上次登入</SPAN>是在 <SPAN class="testoScuro"><xsl:apply-templates select="/USERMODEL/STATEDATA/VAR[@name='last login']"/></SPAN>。<BR/>
	  您的信箱包括以下的收信匣（信件總數是 <SPAN class="testoVerde">綠色</SPAN>，新信件是 <SPAN class="testoRosso">紅色</SPAN>) (<A HREF="{$base}/help?session-id={$session-id}&amp;helptopic=mailbox">求救</A>）：<BR/><BR/>
	      <A HREF="{$base}/mailbox?session-id={$session-id}&amp;force-refresh=1">強制重整</A> - 按這裡以強制重新整理收信匣資訊。
	</P>
	    <TABLE width="100%" border="0" cellspacing="0" cellpadding="3">
	      <xsl:for-each select="/USERMODEL/MAILHOST_MODEL">
		<xsl:apply-templates select="."/>
	      </xsl:for-each>
	    </TABLE>
      </BODY>


    </HTML>
  </xsl:template>
  
  <xsl:template match="/USERMODEL/USERDATA/INTVAR">
    <xsl:value-of select="@value"/>
  </xsl:template>		    
  
  <xsl:template match="/USERMODEL/STATEDATA/VAR">
    <xsl:value-of select="@value"/>
  </xsl:template>		    

  <xsl:template match="/USERMODEL/MAILHOST_MODEL">
    <TR>
      <TD COLSPAN="{/USERMODEL/STATEDATA/VAR[@name='max folder depth']/@value}" WIDTH="50%" bgcolor="#A6B1C0" class="testoGrande">
        <xsl:choose>
	  <xsl:when test='@error != ""'>
	    <SPAN class="testoRosso"><xsl:value-of select="@name"/></SPAN> （錯誤： <xsl:value-of select="@error"/>）
	  </xsl:when>
	  <xsl:otherwise>
	    <SPAN class="testoVerde"><xsl:value-of select="@name"/></SPAN>
          </xsl:otherwise>
        </xsl:choose>	    
      </TD>
      <TD bgcolor="#909CAF" width="48%" class="testoScuro">
	電子郵件伺服器： <xsl:value-of select="@url"/>
      </TD>
      <TD bgcolor="#909CAF" width="2%" class="testoScuro">
	&#160;
      </TD>
    </TR>
    <xsl:for-each select="FOLDER[@subscribed='true']">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="FOLDER">
    <xsl:variable name="level" select="count(ancestor::FOLDER)"/>
    <TR>
      <xsl:call-template name="recurse-folder">
         <xsl:with-param name="level" select="$level"/>
      </xsl:call-template>
      <TD bgcolor="#E2E6F0" align="right"><IMG SRC="{$imgbase}/images/folder.gif"/></TD>
      <xsl:choose>
	<xsl:when test="@holds_messages = 'true'">
	  <TD bgcolor="#E2E6F0" COLSPAN="{/USERMODEL/STATEDATA/VAR[@name='max folder depth']/@value - $level - 1}" valign="middle" class="testoGrande">
	    <A HREF="{$base}/folder/list?session-id={$session-id}&amp;folder-id={@id}&amp;part=1"><xsl:value-of select="@name"/></A>
	  </TD>
	  <TD WIDTH="48%" bgcolor="#D3D8DE" valign="middle" class="testoNero">
	    <SPAN class="testoVerde"><xsl:value-of select="MESSAGELIST/@total"/></SPAN>/<SPAN class="testoRosso"><xsl:value-of select="MESSAGELIST/@new"/></SPAN> 封信件
	  </TD>
     <TD width="2%" class="testoScuro">
	&#160;
      </TD>	
	</xsl:when>
	<xsl:otherwise>
	  <TD bgcolor="#E2E6F0" COLSPAN="{/USERMODEL/STATEDATA/VAR[@name='max folder depth']/@value - $level - 1}" valign="middle" class="testoGrande">
	    <xsl:value-of select="@name"/>
	  </TD>
	  <TD WIDTH="48%" bgcolor="#D3D8DE" valign="middle" class="testoNero">
	    不能含有信件
	  </TD>
     <TD width="2%" class="testoScuro">
	&#160;
      </TD>
	</xsl:otherwise>
      </xsl:choose>
    </TR>
    

    <xsl:for-each select="FOLDER">
      <xsl:apply-templates select="."/>
    </xsl:for-each>    
  </xsl:template>


  <!-- Create an appropriate number of <TD></TD> before a folder, depending on the level -->
  <xsl:template name="recurse-folder">
    <xsl:param name="level"/>
    <xsl:if test="$level>0">
      <TD bgcolor="#E2E6F0" class="testoNero">&#160;</TD>
      <xsl:variable name="levelneu" select="$level - 1"/>
      <xsl:call-template name="recurse-folder">
	<xsl:with-param name="level" select="$levelneu"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
