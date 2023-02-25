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
  
    <xsl:variable name="imgbase" select="/USERMODEL/STATEDATA/VAR[@name='img base uri']/@value"/>
    <xsl:variable name="base" select="/USERMODEL/STATEDATA/VAR[@name='base uri']/@value"/>
    <xsl:variable name="session-id" select="/USERMODEL/STATEDATA/VAR[@name='session id']/@value"/>

    <xsl:template match="/">

    <HTML>
      <HEAD>
        <TITLE>WebMail Mailbox for <xsl:value-of select="/USERMODEL/USERDATA/FULL_NAME"/>: Showing message <xsl:value-of select="/USERMODEL/CURRENT[@type='message']/@id"/></TITLE>
	<META CONTENT="AUTHOR" VALUE="Sebastian Schaffert"/>
      </HEAD>
      
      <BODY bgcolor="#ffffff">
	<xsl:variable name="current_msg" select="/USERMODEL/CURRENT[@type='message']/@id"/>
	<xsl:variable name="current_folder" select="/USERMODEL/CURRENT[@type='folder']/@id"/>
	<xsl:apply-templates select="/USERMODEL/MAILHOST_MODEL//FOLDER[@id=$current_folder]//MESSAGE[@msgid=$current_msg]"/>
      </BODY>
    </HTML>
  </xsl:template>

  <xsl:template match="MESSAGE">

    <xsl:call-template name="navigation"/>    

    <TABLE WIDTH="100%" BGCOLOR="#dddddd" CELLSPACING="0" BORDER="0">
      <TR>
	<TD COLSPAN="3">
	    <xsl:apply-templates select="HEADER/SUBJECT"/>
	</TD>
	<TD ALIGN="right">(<A HREF="{$base}/help?session-id={$session-id}&amp;helptopic=messagelist">Help</A>)</TD>
      </TR>
      <TR>
	<TD WIDTH="10%" VALIGN="top">
	  <STRONG>From:</STRONG>
	</TD>
	<TD WIDTH="40%" VALIGN="top">
	  <xsl:apply-templates select="HEADER/FROM"/>
	</TD>
	<TD WIDTH="10%" VALIGN="top">
	  <STRONG>To:</STRONG>
	</TD>
	<TD WIDTH="40%" VALIGN="top">
	  <xsl:for-each select="HEADER/TO">
	    <xsl:apply-templates select="."/><BR/>
	  </xsl:for-each>
	</TD>
      </TR>
      <TR>
	<TD VALGIN="top">
	  <STRONG>Reply-To:</STRONG>
	</TD>
	<TD VALIGN="top">
	  <xsl:apply-templates select="HEADER/REPLY_TO"/>
	  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
	</TD>
	<TD VALIGN="top">
	  <STRONG>CC:</STRONG>
	</TD>
	<TD VALIGN="top">
	  <xsl:for-each select="HEADER/CC">
	    <xsl:apply-templates select="."/><BR/>
	  </xsl:for-each>
	  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
	</TD>
      </TR>
      <TR>
	<TD>
	  <STRONG>Date:</STRONG>
	</TD>
	<TD COLSPAN="3">
	  <xsl:apply-templates select="HEADER/DATE"/>
	</TD>
      </TR>
      <TR>
	<TD COLSPAN="4" ALIGN="right">
	  <A HREF="{$base}/compose?session-id={$session-id}&amp;folder-id={/USERMODEL/CURRENT[@type='folder']/@id}&amp;message-nr={@msgnr}&amp;reply=1">reply to this message...</A> - 
	  <A HREF="{$base}/compose?session-id={$session-id}&amp;folder-id={/USERMODEL/CURRENT[@type='folder']/@id}&amp;message-nr={@msgnr}&amp;forward=1">forward this message...</A>
	</TD>
      </TR>
    </TABLE>

    <xsl:for-each select="PART">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    
    <TABLE WIDTH="100%" BGCOLOR="#dddddd" CELLSPACING="0" BORDER="0">
      <TR>
	<FONT SIZE="-1">
	  <FORM ACTION="{$base}/folder/list?flag=1&amp;session-id={$session-id}&amp;folder-id={/USERMODEL/CURRENT[@type='folder']/@id}" METHOD="POST">
	    <TD>
	      <INPUT TYPE="HIDDEN" NAME="CH%{@msgnr}" VALUE="on"/>
	      <SELECT NAME="MARK">
		<OPTION VALUE="MARK">set</OPTION>
		<OPTION VALUE="UNMARK">remove</OPTION>
	      </SELECT>
	      <STRONG>message flag</STRONG>
	      <SELECT NAME="MESSAGE FLAG">
		<OPTION VALUE="DELETED">deleted</OPTION>
		<OPTION VALUE="SEEN">seen</OPTION>
		<OPTION VALUE="ANSWERED">answered</OPTION>
		<OPTION VALUE="RECENT">recent</OPTION>
		<OPTION VALUE="DRAFT">draft</OPTION>
	      </SELECT>
	      <INPUT TYPE="SUBMIT" NAME="flagmsgs" VALUE="Perform!"/>
	    </TD>
	  </FORM>
	  <FORM ACTION="{$base}/folder/showmsg?flag=1&amp;session-id={$session-id}&amp;folder-id={/USERMODEL/CURRENT[@type='folder']/@id}" METHOD="POST">
	    <TD>
	      <INPUT TYPE="HIDDEN" NAME="CH%{@msgnr}" VALUE="on"/>
	      <SELECT NAME="COPYMOVE">
		<OPTION VALUE="COPY">copy</OPTION>
		<OPTION VALUE="MOVE">move</OPTION>
	      </SELECT>	   
	      <STRONG>message to folder</STRONG>
	      <SELECT NAME="TO">
		<xsl:for-each select="/USERMODEL/MAILHOST_MODEL//FOLDER">
		  <OPTION value="{@id}"><xsl:value-of select="@name"/></OPTION>
		</xsl:for-each>
	      </SELECT>
	      <INPUT TYPE="SUBMIT" NAME="copymovemsgs" VALUE="Perform!"/>
	    </TD>
	  </FORM>
	</FONT>
      </TR>
    </TABLE>
   
    
    <xsl:call-template name="navigation"/>
    
  </xsl:template>
  
  <xsl:template match="PART">
    <xsl:choose>
      <xsl:when test="@type='text' and @hidden='true'" />
      <xsl:when test="@type='text' and not(@hidden='true')">
	<PRE>
	  <xsl:for-each select="*">
	    <xsl:apply-templates select="."/>
	  </xsl:for-each>
	</PRE>
      </xsl:when>
      <xsl:when test="@type='html'">
	<xsl:for-each select="*">
	  <xsl:apply-templates select="."/>
	</xsl:for-each>
      </xsl:when>
      <xsl:when test="@type='multi'">
	<HR/>
	<xsl:for-each select="PART">
	  <CENTER><EM>MIME part</EM></CENTER><BR/>
	  <xsl:apply-templates select="."/>
	  <HR/>
	</xsl:for-each>		
      </xsl:when>
      <xsl:otherwise>
	<HR/>
	<TABLE WIDTH="100%" BGCOLOR="#f7f3a8" CELLPADDING="0" CELLSPACING="0" BORDER="0">
	  <TR>
	    <TD>
	      <STRONG>Attached file</STRONG>
	    </TD>
	    <TD>
	      <A HREF="{$base}/showmime/{@filename}?session-id={$session-id}&amp;msgid={ancestor::MESSAGE/@msgid}"><xsl:value-of select="@filename"/><xsl:value-of select="@name"/></A>	
	    </TD>
	  </TR>
	  <xsl:if test="@description != ''">
	    <TR>
	      <TD><STRONG>Description:</STRONG></TD>
	      <TD>
		<xsl:value-of select="@description"/>
		<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
	      </TD>
	    </TR>
	  </xsl:if>
	  <TR>
	    <TD><STRONG>Type:</STRONG></TD>
	    <TD><xsl:value-of select="@content-type"/></TD>
	  </TR>
	  <TR>
	    <TD><STRONG>Size:</STRONG></TD>
	    <TD><xsl:value-of select="@size"/> bytes</TD>
	  </TR>
	  <xsl:if test="@type='image' and /USERMODEL/USERDATA/BOOLVAR[@name='show images']/@value = 'yes'">
	    <TR>
	      <TD COLSPAN="2">
		<IMG SRC="{$base}/showmime/{@filename}?session-id={$session-id}&amp;msgid={ancestor::MESSAGE/@msgid}"/>
	      </TD>
	    </TR>
	  </xsl:if>
	</TABLE>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="CONTENT">
    <xsl:choose>
      <xsl:when test="../@type = 'html'">
	<xsl:apply-templates select="*"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:choose>
	  <xsl:when test="@quotelevel > 2">
	    <FONT COLOR="orange">
	      <EM>	    
		<xsl:value-of disable-output-escaping="yes" select="."/>
	      </EM>
	    </FONT>
	  </xsl:when>
	  <xsl:when test="@quotelevel = 2">
	    <FONT COLOR="green">
	      <EM>
		<xsl:value-of disable-output-escaping="yes" select="."/>
	      </EM>
	    </FONT>
	  </xsl:when>
	  <xsl:when test="@quotelevel = 1">
	    <FONT COLOR="blue">
	      <EM>
		<xsl:value-of disable-output-escaping="yes" select="."/>
	      </EM>
	    </FONT>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of disable-output-escaping="yes" select="."/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="navigation">
    <P>
      <TABLE WIDTH="100%">
	<TR>
	  <TD ALIGN="left" VALIGN="center">
	    <EM>
	      <xsl:choose>
		<xsl:when test="@msgnr > 1">
		  <A HREF="{$base}/folder/showmsg?session-id={$session-id}&amp;folder-id={/USERMODEL/CURRENT[@type='folder']/@id}&amp;message-nr={@msgnr - 1}"><IMG SRC="{$imgbase}/images/arrow-left.png" BORDER="0"/> Previous message</A>
		</xsl:when>
		<xsl:otherwise>
		  <IMG SRC="{$imgbase}/images/arrow-left-disabled.png" BORDER="0"/> Previous message
		</xsl:otherwise>
	      </xsl:choose>
	    </EM>
	  </TD>
	  <TD ALIGN="center" VALIGN="center">
	    <EM>
	      <A HREF="{$base}/folder/list?session-id={$session-id}&amp;folder-id={/USERMODEL/CURRENT[@type='folder']/@id}&amp;part={/USERMODEL/CURRENT[@type='folder']/@list_part}"><IMG SRC="{$imgbase}/images/arrow-up.png" BORDER="0"/>message list</A>
	    </EM>
	  </TD>
	  <TD ALIGN="right" VALIGN="center">
	    <xsl:variable name="current_folder" select="/USERMODEL/CURRENT[@type='folder']/@id"/>
	    <EM>
	      <xsl:choose>
		<xsl:when test="@msgnr &lt; /USERMODEL/MAILHOST_MODEL//FOLDER[@id=$current_folder]/MESSAGELIST/@total">
		  <A HREF="{$base}/folder/showmsg?session-id={$session-id}&amp;folder-id={/USERMODEL/CURRENT[@type='folder']/@id}&amp;message-nr={@msgnr + 1}">Next message <IMG SRC="{$imgbase}/images/arrow-right.png" BORDER="0"/></A>
		</xsl:when>
		<xsl:otherwise>
		   Next message <IMG SRC="{$imgbase}/images/arrow-right-disabled.png" BORDER="0"/>
		</xsl:otherwise>
	      </xsl:choose>
	    </EM>
	  </TD>
	</TR>
      </TABLE>    
    </P>
  </xsl:template>

  <xsl:template match="DATE">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="SUBJECT">
    <FONT SIZE="+1" COLOR="darkgreen">
      <STRONG>
	<xsl:value-of select="."/>
      </STRONG>
    </FONT>
  </xsl:template>

  <xsl:template match="TO">
    <EM><xsl:value-of select="."/></EM>
  </xsl:template>

  <xsl:template match="CC">
    <EM><xsl:value-of select="."/></EM>
  </xsl:template>

  <xsl:template match="REPLY-TO">
    <EM><xsl:value-of select="."/></EM>
  </xsl:template>
    
  <xsl:template match="FROM">
    <xsl:choose>
      <xsl:when test="contains(.,'&lt;')">
        <EM><xsl:value-of select="substring-before(.,'&lt;')"/></EM>,
        <xsl:value-of select="substring-before(substring-after(.,'&lt;'),'>')"/>
       </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <!-- The following three sections deal with displaying HTML code from HTML attachments.
  Elements marked "malicious" will get a special treatment -->
  <xsl:template match="@*|node()"> 
    <xsl:choose>
      <xsl:when test="not(@malicious)">
	<xsl:copy>
	  <xsl:apply-templates select="@*|node()"/>
	</xsl:copy> 
      </xsl:when>
      <xsl:otherwise>
	<TABLE  BORDER="1" WIDTH="100%" CELLSPACING="0" CELLPADDING="0">
	  <TR>
	    <TD BGCOLOR="#FF9933">
	      Untrusted HTML element removed: <xsl:value-of select="@malicious"/>
	    </TD>
	  </TR>
	  <TR>
	    <TD bgcolor="#3399FF" >
	      <xsl:apply-templates select="." mode="quote"/>
	    </TD>
	  </TR>
	</TABLE>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="node()" mode="quote"> 
    <xsl:choose>
      <xsl:when test="name(.)">
	&lt;<xsl:value-of select="name(.)"/>
	<xsl:text> </xsl:text><xsl:apply-templates select="@*" mode="quote"/>
	<xsl:if test="./node()">
	  &gt;
	  <xsl:apply-templates select="node()" mode="quote"/>	    
	  &lt;/<xsl:value-of select="name(.)"/>
	</xsl:if>
	&gt;
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*" mode="quote"> 
    <xsl:if test="name(.) != 'malicious'">
      <xsl:text> </xsl:text><xsl:value-of select="name(.)"/>="<xsl:value-of select="."/>"
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
