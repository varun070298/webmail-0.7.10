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
  <xsl:output method="html" indent="no"/>
  
  
  <xsl:variable name="imgbase" select="/USERMODEL/STATEDATA/VAR[@name='img base uri']/@value"/>
  <xsl:variable name="base" select="/USERMODEL/STATEDATA/VAR[@name='base uri']/@value"/>
  <xsl:variable name="session-id" select="/USERMODEL/STATEDATA/VAR[@name='session id']/@value"/>
  
  <xsl:variable name="work" select="/USERMODEL/WORK/MESSAGE[position()=1]"/>

    <xsl:template match="/">

    <HTML>
      <HEAD>
        <TITLE><xsl:value-of select="/USERMODEL/USERDATA/FULL_NAME"/> postal�d�ja: �zenet megjelen�t�se <xsl:value-of select="/USERMODEL/CURRENT[@type='message']/@id"/></TITLE>
	<META CONTENT="AUTHOR" VALUE="Sebastian Schaffert"/>
	<link rel="stylesheet" href="{$base}/passthrough/webmail.css"/>
      </HEAD>
      
      <BODY bgcolor="#B5C1CF" topmargin="5" leftmargin="0" marginwidth="0" marginheight="5">
	<FORM ACTION="{$base}/send?session-id={$session-id}" METHOD="POST">
	  <TABLE width="100%" border="0" cellspacing="2" cellpadding="4">
	    <TR>
	      <TD colspan="2" height="22" class="testoNero"><IMG SRC="{$imgbase}/images/icona_composer.gif" BORDER="0" align="absmiddle"/>
	      �zenet �r�sa... (<A HREF="{$base}/help?session-id={$session-id}&amp;helptopic=compose">Seg�ts�g</A>)
		</TD>
	    </TR>
	    <TR>
	      <TD colspan="2" bgcolor="#697791" height="22" class="testoBianco">
 		D�tum: <xsl:value-of select="/USERMODEL/STATEDATA/VAR[@name='date']/@value"/>
	      </TD>
	    </TR>
           <TR>
             <TD height="22" class="testoGrande" width="13%" bgcolor="#E2E6F0">K�ld�:</TD>
             <TD height="22" class="testoNero" width="87%" bgcolor="#E2E6F0">
               <select class="testoNero" name="FROM" size="1">
                 <xsl:for-each select="/USERMODEL/USERDATA/EMAIL/ADDY">
                <xsl:choose>
                  <xsl:when test="$work/HEADER/FROM!=''">
                   <xsl:choose>
                         <xsl:when test="$work/HEADER/FROM=current()">
                           <option selected="selected">
                                  <xsl:value-of select="."/>
                            </option>
                          </xsl:when>
                          <xsl:otherwise>
                           <option>
                                <xsl:value-of select="."/>
                                  </option>
                          </xsl:otherwise>
                        </xsl:choose>
                  </xsl:when>
                <xsl:otherwise>
                   <xsl:choose>
                     <xsl:when test="@default='yes'">
                       <option selected="selected">
                              <xsl:value-of select="."/>
                            </option>
                          </xsl:when>
                          <xsl:otherwise>
                       <option>
                            <xsl:value-of select="."/>
                          </option>
                          </xsl:otherwise>
                        </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
             </xsl:for-each>
           </select>
           </TD>
           </TR>
	    <TR>
	      <TD height="22" class="testoGrande" width="13%" bgcolor="#E2E6F0">C�mzett:</TD>
	      <TD height="22" class="testoNero" width="87%" bgcolor="#E2E6F0">
		  <INPUT TYPE="TEXT" NAME="TO" SIZE="80" class="testoNero" VALUE="{$work/HEADER/TO}"/>
		</TD>
	    </TR>
	    <TR>
		<TD height="22" class="testoGrande" width="13%" bgcolor="#D1D7E7">	      
 		  M�solat:
		</TD>
	      <TD height="22" class="testoNero" width="87%" bgcolor="#D1D7E7">
		  <INPUT TYPE="TEXT" NAME="CC" SIZE="80" class="testoNero" VALUE="{$work/HEADER/CC}"/>
		</TD>
	    </TR>
	    <TR>
	      <TD height="22" class="testoGrande" width="13%" bgcolor="#E2E6F0">
		  V�laszc�m:
		</TD>
	      <TD height="22" class="testoNero" width="87%" bgcolor="#E2E6F0">
		  <INPUT TYPE="TEXT" NAME="REPLY-TO" SIZE="80" class="testoNero" VALUE="{$work/HEADER/REPLY_TO}"/>
		</TD>
	    </TR>
	    <TR>
	      <TD height="22" class="testoGrande" width="13%" bgcolor="#D1D7E7">
		  Titkos m�solat:
		</TD>
	      <TD height="22" class="testoNero" width="87%" bgcolor="#D1D7E7">
		  <INPUT TYPE="TEXT" NAME="BCC" SIZE="80" class="testoNero" VALUE="{$work/HEADER/BCC}"/>
		</TD>
	    </TR>
	    <TR>
	      <TD height="22" class="testoGrande" width="13%" bgcolor="#E2E6F0">
		  T�rgy:
		</TD>
	      <TD height="22" class="testoNero" width="87%" bgcolor="#E2E6F0">
		  <INPUT TYPE="TEXT" NAME="SUBJECT" SIZE="80" class="testoNero" VALUE="{$work/HEADER/SUBJECT}"/>
		</TD>
	    </TR>
	    <TR>
	      <TD height="22" class="testoGrande" width="13%" bgcolor="#D1D7E7">
		  Csatol�sok:
		</TD>
	      <TD height="22" class="testoNero" width="87%" bgcolor="#D1D7E7">
		<xsl:for-each select="$work/PART[position()=1]//PART[@type='binary']">
		  <xsl:apply-templates select="."/>
		</xsl:for-each>
	        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
	      </TD>
	    </TR>
	    <TR>
	      <TD height="22" class="testoNero" width="13%" bgcolor="#E2E6F0">
		  <INPUT TYPE="SUBMIT" class="testoNero" VALUE="F�jlok csatol�sa..." NAME="ATTACH"/>
		</TD>
	      <TD class="testoNero" align="right" width="87%" bgcolor="#E2E6F0">
		  <INPUT TYPE="SUBMIT" class="testoNero" VALUE="�zenet k�ld�se..." NAME="SEND"/>
		</TD>
	    </TR>
	    <TR>
 		<TD bgcolor="#D1D7E7" height="22" class="testoNero" align="center">&#160;
		</TD>
	      <TD bgcolor="#D1D7E7" height="22" class="testoNero">
		<TEXTAREA NAME="BODY" COLS="80" ROWS="40" class="testoNero" wrap="physical">
		  <xsl:for-each select="$work/PART[position()=1]/PART[position()=1]/CONTENT">
		    <xsl:apply-templates select="."/>
		  </xsl:for-each>
		</TEXTAREA>
	      </TD>
	    </TR>
	    <TR>
	      <TD height="22" class="testoNero" width="13%" bgcolor="#E2E6F0">
		  <INPUT TYPE="SUBMIT" class="testoNero" VALUE="F�jlok csatol�sa..." NAME="ATTACH"/>
		</TD>
	      <TD class="testoNero" align="right" width="87%" bgcolor="#E2E6F0">
		  <INPUT TYPE="SUBMIT" class="testoNero" VALUE="�zenet k�ld�se..." NAME="SEND"/>
		</TD>
	    </TR>
	  </TABLE>
	</FORM>	
      </BODY>
    </HTML>
  </xsl:template>

  
  <!-- All parts that are attachments (= have a file name) should be displayed with their name and
       size only -->
  <xsl:template match="PART">
    <xsl:if test="@filename != ''">
      <xsl:value-of select="@filename"/> (<xsl:value-of select="@size"/> bytes),
    </xsl:if>
  </xsl:template>


  <!-- Content of a message should be displayed plain -->
  <xsl:template match="CONTENT">
    <xsl:value-of select="."/>
  </xsl:template>
</xsl:stylesheet>
