<?xml version="1.0" encoding="ISO-8859-1"?>
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
<!-- This is part of the French translation of WebMail - Christian SENET - senet@lpm.u-nancy.fr - 2002 -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" indent="yes"/>
  
    <xsl:variable name="imgbase" select="/USERMODEL/STATEDATA/VAR[@name='img base uri']/@value"/>
    <xsl:variable name="base" select="/USERMODEL/STATEDATA/VAR[@name='base uri']/@value"/>
    <xsl:variable name="session-id" select="/USERMODEL/STATEDATA/VAR[@name='session id']/@value"/>

    <xsl:template match="/">
    
    <HTML>
      <HEAD>
        <TITLE>Boite aux Lettres WebMail de <xsl:value-of select="/USERMODEL/USERDATA/FULL_NAME"/>: Setup Dossier</TITLE>
	<META CONTENT="AUTHOR" VALUE="Sebastian Schaffert"/>
	<META CONTENT="GENERATOR" VALUE="JWebMail 0.7 XSL"/>
	<link rel="stylesheet" href="{$base}/passthrough/webmail.css"/>
      </HEAD>
      
      <BODY bgcolor="#B5C1CF" topmargin="5" leftmargin="0" marginwidth="0" marginheight="5">		  
	<TABLE width="100%" border="0" cellspacing="2" cellpadding="4">
  <TR> 
	    <TD colspan="4" height="22" class="testoNero">
	      <IMG SRC="{$imgbase}/images/icona_folder.gif" align="absmiddle"/>
	    Setup Dossier WebMail de <xsl:value-of select="/USERMODEL/USERDATA/FULL_NAME"/> (<A HREF="{$base}/help?session-id={$session-id}&amp;helptopic=folder-setup-folders">Aide</A>)
    </TD>
	   </TR>
	   <TR>
	    <TD colspan="4" bgcolor="#697791" height="22" class="testoBianco">
	        Nom de login <xsl:value-of select="normalize-space(/USERMODEL/USERDATA/LOGIN)"/>
	   </TD>
	  </TR>
	</TABLE>
	 
	<TABLE WIDTH="100%" border="0" cellspacing="0" cellpadding="3">
	  <xsl:for-each select="/USERMODEL/MAILHOST_MODEL">
	    <xsl:apply-templates select="."/>
	  </xsl:for-each>
	</TABLE>
     
	<P class="testoChiaro">
	  Les Dossiers affich?s en <SPAN class="bold">gras</SPAN> peuvent contenir des sous-dossiers, et les dossiers qui sont affich?s normalement ne peuvent contenir de sous-dossiers. Les Dossiers affich?s en <I>italique</I> sont masqu?s (dans la vue principale des bo?tes aux lettres), les autres non.
	</P>
	<P class="testoChiaro">
	  <SPAN class="testoRosso">Attention!</SPAN> si vous effacez un dossier, tous les messages (et sous-dossiers) seront <SPAN class="testoRosso">effac?s</SPAN> non seulement de WebMail mais aussi <SPAN class="testoRosso">physiquement de l'h?te serveur de messagerie!</SPAN> Ceci est dangereux et ne pourra ?tre d?fait!
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
      <TD bgcolor="#909CAF" width="58%" class="testoScuro">H?te: <xsl:value-of select="@url"/>
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
	    <A HREF="{$base}/folder/setup?session-id={$session-id}&amp;method=folderadd&amp;addto={@id}">Ajouter sous-dossier</A> - <A HREF="{$base}/folder/setup?session-id={$session-id}&amp;method=folder&amp;remove={@id}&amp;recurse=1">Effacer ce dossier (et tous les sous-dossiers)</A> - 
	    <xsl:choose>
	      <xsl:when test="@subscribed = 'true'">
		<A HREF="{$base}/folder/setup?session-id={$session-id}&amp;method=folder&amp;hide={@id}&amp;">Le Masquer</A>
	      </xsl:when>
	      <xsl:otherwise>
		<A HREF="{$base}/folder/setup?session-id={$session-id}&amp;method=folder&amp;unhide={@id}&amp;">Ne pas le Masquer</A>
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
	    <A HREF="{$base}/folder/setup?session-id={$session-id}&amp;method=folder&amp;remove={@id}">Effacer ce Dossier</A> - 
	    <xsl:choose>
	      <xsl:when test="@subscribed = 'true'">
		<A HREF="{$base}/folder/setup?session-id={$session-id}&amp;method=folder&amp;hide={@id}&amp;">Le Masquer</A>
	      </xsl:when>
	      <xsl:otherwise>
		<A HREF="{$base}/folder/setup?session-id={$session-id}&amp;method=folder&amp;unhide={@id}&amp;">Ne pas le Masquer</A>
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
