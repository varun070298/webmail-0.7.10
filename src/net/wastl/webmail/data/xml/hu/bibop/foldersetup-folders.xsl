<?xml version="1.0" encoding="ISO-8859-2"?>
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
        <TITLE>WebMail Mailbox for <xsl:value-of select="/USERMODEL/USERDATA/FULL_NAME"/>: Mappa be�ll�t�s</TITLE>
	<META CONTENT="AUTHOR" VALUE="Sebastian Schaffert"/>
	<META CONTENT="GENERATOR" VALUE="JWebMail 0.7 XSL"/>
	<link rel="stylesheet" href="{$base}/passthrough/webmail.css"/>
      </HEAD>
      
      <BODY bgcolor="#B5C1CF" topmargin="5" leftmargin="0" marginwidth="0" marginheight="5">		  
	<TABLE width="100%" border="0" cellspacing="2" cellpadding="4">
  <TR> 
	    <TD colspan="4" height="22" class="testoNero">
	      <IMG SRC="{$imgbase}/images/icona_folder.gif" align="absmiddle"/>
	    WebMail mappa be�ll�t�s <xsl:value-of select="/USERMODEL/USERDATA/FULL_NAME"/> sz�m�ra (<A HREF="{$base}/help?session-id={$session-id}&amp;helptopic=folder-setup-folders">S�g�</A>)
    </TD>
	   </TR>
	   <TR>
	    <TD colspan="4" bgcolor="#697791" height="22" class="testoBianco">
	        Bejelentkez�si n�v <xsl:value-of select="normalize-space(/USERMODEL/USERDATA/LOGIN)"/>
	   </TD>
	  </TR>
	</TABLE>
	 
	<TABLE WIDTH="100%" border="0" cellspacing="0" cellpadding="3">
	  <xsl:for-each select="/USERMODEL/MAILHOST_MODEL">
	    <xsl:apply-templates select="."/>
	  </xsl:for-each>
	</TABLE>
     
	<P class="testoChiaro">
	  A <SPAN class="bold">vastag</SPAN> bet�vel ki�rt mapp�k tartalmazhatnak almapp�kat, m�g a norm�l bet�vel ki�rt mapp�k nem. A <I>d�lt</I> bet�vel jel�lt mapp�k rejtettek (a mapp�k f�k�perny�j�n), a t�bbiek l�that�ak.
	</P>
	<P class="testoChiaro">
	  <SPAN class="testoRosso">Figyelmeztet�s!</SPAN> Ha t�r�l egy mapp�t, minden �zenet (�s almappa)  <SPAN class="testoRosso">t�rl�dik</SPAN>, nem csak a webmailb�l, de <SPAN class="testoRosso">fizikailag is t�rl�dik a kiszolg�l�r�l</SPAN>! Nem lehet visszavonni az utas�t�st!
	</P>
	
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
      <TD COLSPAN="{/USERMODEL/STATEDATA/VAR[@name='max folder depth']/@value}" WIDTH="40%" bgcolor="#A6B1C0" class="testoGrande">
	<SPAN class="testoVerde"><xsl:value-of select="@name"/></SPAN>
      </TD>
      <TD bgcolor="#909CAF" width="58%" class="testoScuro">Host: <xsl:value-of select="@url"/>
      </TD>
      <TD bgcolor="#909CAF" width="2%" class="testoScuro">
	&#160;
      </TD>
    </TR>
    <xsl:for-each select="FOLDER">
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
	<xsl:when test="@holds_folders = 'true'">
	  <TD bgcolor="#E2E6F0" COLSPAN="{/USERMODEL/STATEDATA/VAR[@name='max folder depth']/@value - $level - 1}" valign="middle" class="testoGrande">
            <xsl:choose>
	      <xsl:when test="@subscribed = 'true'">              
	        <STRONG><xsl:value-of select="@name"/></STRONG>
              </xsl:when>
              <xsl:otherwise>
                <EM><STRONG><xsl:value-of select="@name"/></STRONG></EM>
              </xsl:otherwise>
            </xsl:choose>
	  </TD>
	  <TD WIDTH="58%" bgcolor="#D3D8DE" valign="middle" class="testoNero">
	    <A HREF="{$base}/folder/setup?session-id={$session-id}&amp;method=folderadd&amp;addto={@id}">Add subfolder</A> - <A HREF="{$base}/folder/setup?session-id={$session-id}&amp;method=folder&amp;remove={@id}&amp;recurse=1">Mappa (�s almapp�k) elt�vol�t�sa</A> - 
	    <xsl:choose>
	      <xsl:when test="@subscribed = 'true'">
		<A HREF="{$base}/folder/setup?session-id={$session-id}&amp;method=folder&amp;hide={@id}&amp;">Elrejt</A>
	      </xsl:when>
	      <xsl:otherwise>
		<A HREF="{$base}/folder/setup?session-id={$session-id}&amp;method=folder&amp;unhide={@id}&amp;">Megjelen�t</A>
	      </xsl:otherwise>
	    </xsl:choose>
	  </TD>
     <TD width="2%" class="testoScuro">
	&#160;
      </TD>
	</xsl:when>
	<xsl:otherwise>
	  <TD COLSPAN="{/USERMODEL/STATEDATA/VAR[@name='max folder depth']/@value - $level - 1}">
            <xsl:choose>
	      <xsl:when test="@subscribed = 'true'">              
	        <xsl:value-of select="@name"/>
              </xsl:when>
              <xsl:otherwise>
                <EM><xsl:value-of select="@name"/></EM>
              </xsl:otherwise>
            </xsl:choose>
	  </TD>
	  <TD>
	    <A HREF="{$base}/folder/setup?session-id={$session-id}&amp;method=folder&amp;remove={@id}">Mappa elt�vol�t�sa</A> - 
	    <xsl:choose>
	      <xsl:when test="@subscribed = 'true'">
		<A HREF="{$base}/folder/setup?session-id={$session-id}&amp;method=folder&amp;hide={@id}&amp;">Elrejt</A>
	      </xsl:when>
	      <xsl:otherwise>
		<A HREF="{$base}/folder/setup?session-id={$session-id}&amp;method=folder&amp;unhide={@id}&amp;">Megjelen�t</A>
	      </xsl:otherwise>
	    </xsl:choose>	
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
