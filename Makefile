
LEGACY_CFLAGS = -Ilegacy
OBJCOPY = objcopy
CFLAGS = -Wall -Werror
CC = gcc
LD = gcc
AR = ar

DISTNAME = func_renaming

LIBSYSTEM_REDEFINES := \
	$(shell ./create_redefines.sh 'n' 's/.*/__system_&/' <legacy/aliases)
LIBLEGACY_REDEFINES_PHASE_ONE := \
	$(shell ./create_redefines.sh 'n' 's/.*/__system_&/' <legacy/aliases)
LIBLEGACY_REDEFINES_PHASE_TWO := \
	$(shell ./create_redefines.sh 's/.*/legacy_&/' 'n' <legacy/aliases)
	
	

.PHONY: all clean .patch_system .patch_self

.SECONDARY:

all: app

run: app
	./app

app: ported/app.o liblegacy.a
	$(LD) -o $@ $^  

system/libsystem.a: system/system.o
	$(AR) rcs $@ $^

legacy/liblegacy.a: legacy/delta.o legacy/system.o
	$(AR) rcs $@ $^
	
liblegacy.a: .patch_system .patch_self
	$(AR) rcs $@ legacy/patched_system/*.o legacy/patched_self/*.o
	
.patch_system: system/libsystem.a
	@cd legacy/patched_system; \
		rm -f *; \
		$(AR) x ../../$<; \
		for f in *.o; do \
			echo "Patching $$f..."; \
			$(OBJCOPY) $(LIBSYSTEM_REDEFINES) $$f $$f; \
		done

.patch_self: legacy/liblegacy.a
	cd legacy/patched_self; \
		rm -f *; \
		$(AR) x ../../$<; \
		for f in *.o; do \
			echo "Patching $$f..."; \
			$(OBJCOPY) $(LIBLEGACY_REDEFINES_PHASE_ONE) $$f $$f; \
			$(OBJCOPY) $(LIBLEGACY_REDEFINES_PHASE_TWO) $$f $$f; \
		done

ported/%.o: ported/%.c
	$(CC) -c $(CFLAGS) $(LEGACY_CFLAGS) -o $@ $<

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
	find -name '*.o' -or -name 'lib*.a' -delete
	rm -f app
	
