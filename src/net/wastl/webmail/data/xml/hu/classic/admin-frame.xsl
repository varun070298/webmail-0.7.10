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
  <xsl:output method="html" encoding="UTF-8"/>

    <xsl:variable name="imgbase" select="/GENERIC/MODEL/STATEDATA/VAR[@name='img base uri']/@value"/>
    <xsl:variable name="base" select="/GENERICMODEL/STATEDATA/VAR[@name='base uri']/@value"/>
    <xsl:variable name="session-id" select="/GENERICMODEL/STATEDATA/VAR[@name='session id']/@value"/>
  
    <xsl:template match="/">

    <HTML>
      <HEAD>
        <TITLE>WebMail Administration Interface</TITLE>
	<META CONTENT="AUTHOR" VALUE="Sebastian Schaffert"/>
      </HEAD>

      <FRAMESET COLS="120,*" border="0">
	<FRAME NAME="Content"  SRC="{$base}/admin/navigation?session-id={$session-id}" scrolling="auto"/>
	<FRAME NAME="Main"   SRC="{$base}/admin/system?session-id={$session-id}" scrolling="auto"/>
      </FRAMESET>    
    </HTML>

  </xsl:template>
</xsl:stylesheet>
