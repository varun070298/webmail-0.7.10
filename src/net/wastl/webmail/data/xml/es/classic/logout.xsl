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
  <xsl:template match="/">
    <HTML>
      <HEAD>
        <TITLE>WebMail Casilla de correo para <xsl:value-of select="/USERMODEL/USERDATA/FULL_NAME"/>: Title Frame</TITLE>
        <META CONTENT="AUTHOR" VALUE="Sebastian Schaffert"/>
        <META HTTP-EQUIV="REFRESH" CONTENT="5;URL={/USERMODEL/STATEDATA/VAR[@name='base uri']/@value}/"/>
      </HEAD>
      <BODY bgcolor="#ffffff">
        <H1>
          <CENTER>&#161;Gracias por usar Webmail!</CENTER>
        </H1>
        <H3>
          <CENTER>Preparando salida para <xsl:value-of select="/USERMODEL/USERDATA/FULL_NAME"/>.</CENTER>
        </H3>
        <P>
          <CENTER>
	    Por favor, aguarda mientras se cierra tu sesi&#243;n y tu configuraci&#243;n
	    est&#225; siendo guardada en el disco.<BR/>
	    If you don't see the <STRONG>pantalla-de-ingreso</STRONG> in a few seconds, please 
	    <A HREF="{/USERMODEL/STATEDATA/VAR[@name='base uri']/@value}/">haz click aqu&#237;</A>.
	  </CENTER>
        </P>
        <P>
          <CENTER>
            <FONT SIZE="-1">
              <EMPH>
		WebMail es (c)1998-2000 de <A HREF="mailto:schaffer@informatik.uni-muenchen.de">Sebastian Schaffert</A>. 
		It is distributed under the terms of the GNU General Public License (LGPL).
	      </EMPH>
            </FONT>
          </CENTER>
        </P>
      </BODY>
    </HTML>
  </xsl:template>
</xsl:stylesheet>
