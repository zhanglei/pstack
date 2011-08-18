#
# This file is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#

VERSION = $(shell awk '/Version:/ { print $$2 }' pstack.spec)
CVSTAG = r$(subst .,-,$(VERSION))

CFLAGS = -Wall -DVERSION=\"$(VERSION)\" $(RPM_OPT_FLAGS)

ifeq ($(RPM_OPT_FLAGS),)
CFLAGS += -g
LDFLAGS += -g
endif

pstack : pstack.c
	$(CC) $(CFLAGS) -o pstack pstack.c

clean:
	rm pstack

install : pstack
	mkdir -p $(BINDIR)
	install -m 755 pstack $(BINDIR)
	mkdir -p $(MANDIR)/man1
	install -m 644 man1/pstack.1 $(MANDIR)/man1

cvstag:
	cvs tag -F $(CVSTAG) .

archive: cvstag
	@rm -rf /tmp/pstack-$(VERSION) /tmp/pstack
	@cd /tmp; cvs export -r$(CVSTAG) pstack; mv pstack pstack-$(VERSION)
	@cd /tmp; tar czSpf pstack-$(VERSION).tar.gz pstack-$(VERSION)
	@rm -rf /tmp/pstack-$(VERSION)
	@cp /tmp/pstack-$(VERSION).tar.gz .
	@echo " "
	@echo "The final archive is ./pstack-$(VERSION).tar.gz."