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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" indent="yes"/>
  <xsl:variable name="imgbase" select="/USERMODEL/STATEDATA/VAR[@name='img base uri']/@value"/>
  <xsl:variable name="base" select="/USERMODEL/STATEDATA/VAR[@name='base uri']/@value"/>
  <xsl:variable name="session-id" select="/USERMODEL/STATEDATA/VAR[@name='session id']/@value"/>
  <xsl:template match="/">
    <HTML>
      <HEAD>
        <TITLE>WebMail Casilla de correo para <xsl:value-of select="/USERMODEL/USERDATA/FULL_NAME"/>: Main Frame/Help</TITLE>
        <META CONTENT="AUTHOR" VALUE="Sebastian Schaffert"/>
      </HEAD>
      <BODY bgcolor="#dddddd">
        <H1>
          <CENTER>WebMail Ayuda</CENTER>
        </H1>
        <P>
          <TABLE WIDTH="100%" BORDER="0">
<!-- Test whether the user has choosen a specific help topic or wants to display the whole
                 help file -->
            <xsl:choose>
              <xsl:when test="/USERMODEL/STATEDATA/VAR[@name='helptopic']">
                <xsl:apply-templates select="/USERMODEL/help/helptopic[@id = /USERMODEL/STATEDATA/VAR[@name='helptopic']/@value]"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="/USERMODEL/help/helptopic"/>
              </xsl:otherwise>
            </xsl:choose>
            <TR>
              <TD COLSPAN="2" ALIGN="CENTER">
                <STRONG>
                  <EMPH>El sistema usa <xsl:apply-templates select="/USERMODEL/STATEDATA/VAR[@name='java virtual machine']"/> on <xsl:apply-templates select="/USERMODEL/STATEDATA/VAR[@name='operating system']"/></EMPH>
                </STRONG>
              </TD>
            </TR>
            <TR>
              <TD COLSPAN="2" ALIGN="CENTER">
                <STRONG>
                  <EMPH>WebMail <xsl:apply-templates select="/USERMODEL/STATEDATA/VAR[@name='webmail version']"/> (c)1999-2001 by Sebastian Schaffert, schaffer@informatik.uni-muenchen.de</EMPH>
                </STRONG>
              </TD>
            </TR>
          </TABLE>
        </P>
      </BODY>
    </HTML>
  </xsl:template>
  <xsl:template match="/USERMODEL/STATEDATA/VAR">
    <xsl:value-of select="@value"/>
  </xsl:template>
  <xsl:template match="helptopic">
    <TR>
      <A NAME="{@id}"/>
      <TD VALIGN="top">
        <xsl:if test="icon">
          <IMG SRC="{$imgbase}/images/{icon/@href}" BORDER="0"/>
        </xsl:if>
      </TD>
      <TD>
        <P>
          <STRONG>
            <xsl:value-of select="@title"/>
          </STRONG>
        </P>
        <xsl:apply-templates select="helpdata"/>
        <P>
          <STRONG>referencias posteriores:</STRONG>
          <xsl:apply-templates select="ref"/>
        </P>
      </TD>
    </TR>
    <TR>
      <TD COLSPAN="2">
        <HR/>
      </TD>
    </TR>
  </xsl:template>
  <xsl:template match="helpdata">
    <P>
      <xsl:apply-templates/>
    </P>
  </xsl:template>
  <xsl:template match="p">
    <P>
      <xsl:apply-templates/>
    </P>
  </xsl:template>
  <xsl:template match="strong">
    <STRONG>
      <xsl:apply-templates/>
    </STRONG>
  </xsl:template>
  <xsl:template match="em">
    <EM>
      <xsl:apply-templates/>
    </EM>
  </xsl:template>
  <xsl:template match="br">
    <BR/>
  </xsl:template>
  <xsl:template match="ul">
    <UL>
      <xsl:apply-templates/>
    </UL>
  </xsl:template>
  <xsl:template match="li">
    <LI>
      <xsl:apply-templates/>
    </LI>
  </xsl:template>
  <xsl:template match="note">
    <TABLE BGCOLOR="yellow" BORDER="1" WIDTH="100%">
      <TR>
        <TD>
          <STRONG>Nota: </STRONG>
          <xsl:apply-templates/>
        </TD>
      </TR>
    </TABLE>
  </xsl:template>
  <xsl:template match="warning">
    <TABLE BGCOLOR="red" BORDER="1" WIDTH="100%">
      <TR>
        <TD>
          <STRONG>Advertencia: </STRONG>
          <xsl:apply-templates/>
        </TD>
      </TR>
    </TABLE>
  </xsl:template>
  <xsl:template match="ref">
    <xsl:variable name="href" select="@ref-id"/>
    <xsl:choose>
      <xsl:when test="/USERMODEL/STATEDATA/VAR[@name='helptopic']"><A HREF="{$base}/help?session-id={$session-id}&amp;helptopic={$href}"><xsl:value-of select="/USERMODEL/help/helptopic[@id = $href]/@title"/></A>,
      </xsl:when>
      <xsl:otherwise><A HREF="#{$href}"><xsl:value-of select="/USERMODEL/help/helptopic[@id = $href]/@title"/></A>, 
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
