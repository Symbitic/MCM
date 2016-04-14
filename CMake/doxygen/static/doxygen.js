/*
 *******************************************************************************
 * Copyright (c) 2015-2016 Mutant Engine Contributors.
 *
 * This file is part of Mutant Engine.
 *
 * Mutant Engine is free software; you can redistribute it and/or modify it
 * under the terms of version 3 of the GNU General Public License, as published
 * by the Free Software Foundation.
 *
 * In addition to the permissions in the GNU General Public License, the authors
 * give you unlimited permission to link the compiled version of Mutant Engine
 * into combinations with other programs, and to distribute those combinations
 * without any restriction coming from the use of Mutant Engine. The
 * restrictions of the GNU General Public License still apply in other respects.
 *
 * Mutant Engine is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * Mutant Engine. If not, see <http://www.gnu.org/licenses/>.
 *******************************************************************************
 */

$( document ).ready(function() {
    /*
    var projectname = $( "#projectname" );
    var text = projectname.text();
    if(text.charAt(0) === 'M') {
        text = text.substring(1);
        console.log(text);
        projectname.text(text);
    }
    */
    /* Trim the first 'M' from the Project Name. */
    if($( "#projectname" ).html().charAt(0) === "M") {
        $( "#projectname" ).html(
            $( "#projectname" ).html().substring(1)
        );
    }
});
