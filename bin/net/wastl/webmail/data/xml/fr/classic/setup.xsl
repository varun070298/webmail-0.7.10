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
<!--
 * 9/24/2000 devink - changed the password setting look a bit to work with the idea
 * of per Authenticator help.
-->
<!-- This is part of the French translation of WebMail - Christian SENET - senet@lpm.u-nancy.fr - 2002 -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" encoding="UTF-8"/>
  
    <xsl:variable name="imgbase" select="/USERMODEL/STATEDATA/VAR[@name='img base uri']/@value"/>
    <xsl:variable name="base" select="/USERMODEL/STATEDATA/VAR[@name='base uri']/@value"/>
    <xsl:variable name="session-id" select="/USERMODEL/STATEDATA/VAR[@name='session id']/@value"/>
    <xsl:variable name="themeset" select="/USERMODEL/STATEDATA/VAR[@name='themeset']/@value"/>
    <xsl:variable name="pass_change_file" select="/USERMODEL/STATEDATA/VAR[@name='pass change file']/@value"/>

    <xsl:template match="/">
    
    <HTML>
      <HEAD>
        <TITLE>Boite aux Lettres WebMail de <xsl:value-of select="/USERMODEL/USERDATA/FULL_NAME"/>: Page de Titre</TITLE>
	<META CONTENT="AUTHOR" VALUE="Sebastian Schaffert"/>
      </HEAD>

      <BODY bgcolor="#ffffff">

	<FORM ACTION="{$base}/setup/submit?session-id={$session-id}" METHOD="POST">
	  <TABLE BGCOLOR="#dddddd" CELLSPACING="0" BORDER="0">
	    <TR>
	      <TD COLSPAN="2" VALIGN="CENTER">
		<IMG SRC="{$imgbase}/images/btn-setup.png"/>
	      </TD>
	      <TD COLSPAN="2" VALIGN="CENTER">
		<FONT SIZE="+2"><STRONG>Setup WebMail de  <xsl:value-of select="normalize-space(/USERMODEL/USERDATA/FULL_NAME)"/></STRONG></FONT> (<A HREF="{$base}/help?session-id={$session-id}&amp;helptopic=setup">Aide</A>)<BR/>
		<EM>Nom de login <xsl:value-of select="normalize-space(/USERMODEL/USERDATA/LOGIN)"/></EM><BR/>
		<EM>Compte existant depuis le <xsl:apply-templates select="/USERMODEL/STATEDATA/VAR[@name='first login']"/></EM>
	      </TD>
	    </TR>
	    <TR>
	      <TD COLSPAN="4" BGCOLOR="#aaaaaa" ALIGN="CENTER"><EM><FONT SIZE="+1">Param�tres G�n�raux</FONT></EM></TD>
	    </TR>
	    <TR>
	      <TD WIDTH="10%"><STRONG>Nom Complet:</STRONG></TD>
	      <TD WIDTH="40%"><INPUT TYPE="TEXT" NAME="FULLNAME" VALUE="{normalize-space(/USERMODEL/USERDATA/FULL_NAME)}" SIZE="30"/></TD>
	      <TD><STRONG>Langue:</STRONG></TD>
	      <TD>
		<SELECT NAME="LANGUAGE">
		  <xsl:for-each select="/USERMODEL/STATEDATA/VAR[@name='language']">
		    <xsl:choose>
		      <xsl:when test="@value = /USERMODEL/USERDATA/LOCALE">
			<OPTION selected="selected"><xsl:apply-templates select="."/></OPTION>
		      </xsl:when>
		      <xsl:otherwise>
			<OPTION><xsl:apply-templates select="."/></OPTION>
		      </xsl:otherwise>
		    </xsl:choose>		   
		  </xsl:for-each>
		</SELECT>
	      </TD>
	    </TR>
	    <TR>
	      <TD><STRONG>Th�me:</STRONG></TD>
	      <TD COLSPAN="3">
		<SELECT NAME="THEME">
		  <xsl:for-each select="/USERMODEL/STATEDATA/VAR[@name = $themeset]">
		    <xsl:choose>
		      <xsl:when test="@value = /USERMODEL/USERDATA/THEME">
			<OPTION selected="selected"><xsl:apply-templates select="."/></OPTION>
		      </xsl:when>
		      <xsl:otherwise>
			<OPTION><xsl:apply-templates select="."/></OPTION>
		      </xsl:otherwise>
		    </xsl:choose>		   
		  </xsl:for-each>
		</SELECT>		  
	      </TD>
	    </TR>
	    <TR>
	      <TD COLSPAN="4" BGCOLOR="#aaaaaa" ALIGN="CENTER"><EM><FONT SIZE="+1">Param�tres de Mot de Passe</FONT></EM></TD>
        </TR>
        <xsl:variable name="cptmpl" select="/USERMODEL/STATEDATA/VAR[@name='pass change tmpl']/@value"/>
        <TR>
          <TD WIDTH="100%" COLSPAN="4" ALIGN="CENTER">
            <xsl:call-template name="changepass_header">
              <xsl:with-param name="cptmpl" select="$cptmpl"/>
              <xsl:with-param name="sd" select="/USERMODEL/STATEDATA/VAR"/>
              <xsl:with-param name="verbose">yes</xsl:with-param>
            </xsl:call-template>
          </TD>
        </TR>
        <TR>
          <TD WIDTH="10%"><STRONG>Changer Mot de Passe:</STRONG></TD>
          <TD WIDTH="40%">
            <xsl:call-template name="changepass_input">
              <xsl:with-param name="cptmpl" select="$cptmpl"/>
              <xsl:with-param name="sd" select="/USERMODEL/STATEDATA/VAR"/>
              <xsl:with-param name="tag">PASSWORD</xsl:with-param>
            </xsl:call-template>
          </TD>
          <TD WIDTH="10%"><STRONG>V�rification Mot de passe:</STRONG></TD>
          <TD WIDTH="40%">
            <xsl:call-template name="changepass_input">
              <xsl:with-param name="cptmpl" select="$cptmpl"/>
              <xsl:with-param name="sd" select="/USERMODEL/STATEDATA/VAR"/>
              <xsl:with-param name="tag">VERIFY</xsl:with-param>
            </xsl:call-template>
          </TD>
        </TR>
	    <TR>
	      <TD COLSPAN="4" BGCOLOR="#aaaaaa" ALIGN="CENTER"><EM><FONT SIZE="+1">Param�tres d'affichage de la Bo�te aux lettres</FONT></EM></TD>
	    </TR>
	    <TR>
	      <TD><STRONG>Messages par page</STRONG></TD>
	      <TD><INPUT TYPE="TEXT" NAME="intvar%max show messages" SIZE="3" VALUE="{/USERMODEL/USERDATA/INTVAR[@name='max show messages']/@value}"/></TD>
	      <TD><STRONG>Taille de la Barre d'ic�ne de Navigation</STRONG></TD>
	      <TD><INPUT TYPE="TEXT" NAME="intvar%icon size" SIZE="3" VALUE="{/USERMODEL/USERDATA/INTVAR[@name='icon size']/@value}"/></TD>
	    </TR>
	    <TR>
	      <TD><STRONG>Afficher Trucs et Astuces</STRONG></TD>
	      <TD>
		<xsl:choose>
		  <xsl:when test="/USERMODEL/USERDATA/BOOLVAR[@name='show fancy']/@value = 'yes'">
		    <INPUT TYPE="CHECKBOX" NAME="boolvar%show fancy" checked="checked"/>
		  </xsl:when>
		  <xsl:otherwise>
		    <INPUT TYPE="CHECKBOX" NAME="boolvar%show fancy"/>
		  </xsl:otherwise>
		</xsl:choose>
	      </TD>
	      <TD><STRONG>Afficher images attach�es</STRONG></TD>
	      <TD>
		<xsl:choose>
		  <xsl:when test="/USERMODEL/USERDATA/BOOLVAR[@name='show images']/@value = 'yes'">
		    <INPUT TYPE="CHECKBOX" NAME="boolvar%show images" checked="checked"/>
		  </xsl:when>
		  <xsl:otherwise>
		    <INPUT TYPE="CHECKBOX" NAME="boolvar%show images"/>
		  </xsl:otherwise>
		</xsl:choose>
	      </TD>
	    </TR>
	    <TR>
	      <TD><STRONG>Autonettoyage de dossiers</STRONG></TD>
	      <TD>
		<xsl:choose>
		  <xsl:when test="/USERMODEL/USERDATA/BOOLVAR[@name='autoexpunge']/@value = 'yes'">
		    <INPUT TYPE="CHECKBOX" NAME="boolvar%autoexpunge" checked="checked"/>
		  </xsl:when>
		  <xsl:otherwise>
		    <INPUT TYPE="CHECKBOX" NAME="boolvar%autoexpunge"/>
		  </xsl:otherwise>
		</xsl:choose>
	      </TD>
	      <TD><STRONG>Activer marqueurs de message</STRONG></TD>
	      <TD>
		<xsl:choose>
		  <xsl:when test="/USERMODEL/USERDATA/BOOLVAR[@name='set message flags']/@value = 'yes'">
		    <INPUT TYPE="CHECKBOX" NAME="boolvar%set message flags" checked="checked"/>
		  </xsl:when>
		  <xsl:otherwise>
		    <INPUT TYPE="CHECKBOX" NAME="boolvar%set message flags"/>
		  </xsl:otherwise>
		</xsl:choose>
	      </TD>
	    </TR>
	    <TR>
	      <TD><STRONG>Retour � la ligne<BR/>(dans 'Afficher' et 'Composer')</STRONG></TD>
	      <TD>
		<xsl:choose>
		  <xsl:when test="/USERMODEL/USERDATA/BOOLVAR[@name='break lines']/@value = 'yes'">
		    <INPUT TYPE="CHECKBOX" NAME="boolvar%break lines" checked="checked"/>
		  </xsl:when>
		  <xsl:otherwise>
		    <INPUT TYPE="CHECKBOX" NAME="boolvar%break lines"/>
		  </xsl:otherwise>
		</xsl:choose>
	      </TD>
	      <TD><STRONG>longueur de ligne max</STRONG></TD>
	      <TD><INPUT TYPE="TEXT" NAME="intvar%max line length" SIZE="3" VALUE="{/USERMODEL/USERDATA/INTVAR[@name='max line length']/@value}"/></TD>
	    </TR>
	    <TR>
	      <TD COLSPAN="4" BGCOLOR="#aaaaaa" ALIGN="CENTER"><EM><FONT SIZE="+1">Param�tres de Composition</FONT></EM></TD>
	    </TR>
	    <TR>
	      <TD><STRONG>Enregistrer message envoy�</STRONG></TD>
	      <TD>
		<xsl:choose>
		  <xsl:when test="/USERMODEL/USERDATA/BOOLVAR[@name='save sent messages']/@value = 'yes'">
		    <INPUT TYPE="CHECKBOX" NAME="boolvar%save sent messages" checked="checked"/>
		  </xsl:when>
		  <xsl:otherwise>
		    <INPUT TYPE="CHECKBOX" NAME="boolvar%save sent messages"/>
		  </xsl:otherwise>
		</xsl:choose>
	      </TD>
	      <TD> dans le dossier </TD>
	      <TD>
		<SELECT NAME="SENTFOLDER">
		  <xsl:for-each select="/USERMODEL/MAILHOST_MODEL//FOLDER">
		    <xsl:choose>
		      <xsl:when test="normalize-space(/USERMODEL/USERDATA/SENT_FOLDER) = @id">
			<OPTION value="{@id}" selected="selected"><xsl:value-of select="@name"/></OPTION>
		      </xsl:when>
		      <xsl:otherwise>
			<OPTION value="{@id}"><xsl:value-of select="@name"/></OPTION>
		      </xsl:otherwise>
		    </xsl:choose>
		  </xsl:for-each>
		</SELECT>
	      </TD>
	    </TR>
	    <TR>
	      <TD><STRONG>Adresse Email:</STRONG></TD>
	      <TD COLSPAN="3"><INPUT TYPE="TEXT" NAME="EMAIL" SIZE="40" VALUE="{normalize-space(/USERMODEL/USERDATA/EMAIL)}"/></TD>
	    </TR>
	    <TR>
	      <TD VALIGN="TOP"><STRONG>Signature:</STRONG></TD>
	      <TD COLSPAN="3">
		<TEXTAREA ROWS="5" COLS="79" NAME="SIGNATURE"><xsl:value-of select="/USERMODEL/USERDATA/SIGNATURE"/></TEXTAREA>
	      </TD>
	    </TR>
	    <TR>
	      <TD COLSPAN="2" BGCOLOR="#aaaaaa">
		<CENTER>
		  <INPUT TYPE="reset" VALUE="Reset"/>
		</CENTER>
	      </TD>
	      <TD COLSPAN="2" BGCOLOR="#aaaaaa">
		<CENTER>
		  <INPUT TYPE="submit" VALUE="Valider"/>
		</CENTER>
	      </TD>
	    </TR>
	  </TABLE>
	</FORM>
	
      </BODY>
      
    </HTML>
  </xsl:template>
  
  <xsl:template match="/USERMODEL/STATEDATA/VAR">
    <xsl:value-of select="@value"/>
  </xsl:template>		    

  <xsl:include href="changepass.xsl"/>


</xsl:stylesheet>
