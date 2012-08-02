
COMPAT_CFLAGS = -Ilegacy
OBJCOPY = objcopy
CFLAGS = -Wall -Werror
CC = gcc
LD = gcc
AR = ar

DISTNAME = func_renaming

LIBSYSTEM_REDEFINES := \
	$(shell ./create_redefines.sh 'n' 's/.*/__system_&/' <legacy/aliases)
LIBCOMPAT_REDEFINES_PHASE_ONE := \
	$(shell ./create_redefines.sh 'n' 's/.*/__system_&/' <legacy/aliases)
LIBCOMPAT_REDEFINES_PHASE_TWO := \
	$(shell ./create_redefines.sh 's/.*/legacy_&/' 'n' <legacy/aliases)
	
	

.PHONY: all clean

.SECONDARY:

all: libsystem.a app

run: app
	./app

app: ported/app.o liblegacy.a
	$(LD) -o $@ $^  

libsystem.a: system/system.o
	$(AR) rcs $@ $^
	
liblegacy.a: legacy/patched_system/system.o legacy/patched_self/delta.o
	$(AR) rcs $@ $^
	
legacy/patched_self/%.o: legacy/%.o
	$(OBJCOPY) $(LIBCOMPAT_REDEFINES_PHASE_ONE) $< legacy/patched_self/__tmp.o
	$(OBJCOPY) $(LIBCOMPAT_REDEFINES_PHASE_TWO) legacy/patched_self/__tmp.o $@
	rm -f legacy/patched_self/__tmp.o

legacy/patched_system/%.o: system/%.o
	$(OBJCOPY) $(LIBSYSTEM_REDEFINES) $< $@

ported/%.o: ported/%.c
	$(CC) -c $(CFLAGS) $(COMPAT_CFLAGS) -o $@ $<

%.o: %.c
	$(CC) -c $(CFLAGS) -o $@ $<

dist:
	mkdir $(DISTNAME)
	mkdir $(DISTNAME)/legacy $(DISTNAME)/legacy/patched_system $(DISTNAME)/legacy/patched_self $(DISTNAME)/ported $(DISTNAME)/system
	
	cp Makefile create_redefines.sh $(DISTNAME)
	cp legacy/*.[hc] legacy/aliases $(DISTNAME)/legacy
	cp ported/*.[hc] $(DISTNAME)/ported
	cp system/*.[hc] $(DISTNAME)/system
	
	tar czf $(DISTNAME).tar.gz $(DISTNAME)
	
	rm -rf $(DISTNAME)

clean:
	find -name '*.o' -delete
	rm -f lib*.a app
	
