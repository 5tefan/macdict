EXECUTABLE = dict

swift: $(EXECUTABLE).swift $(EXECUTABLE).swift.h
	@xcrun swiftc -sdk $(shell xcrun --show-sdk-path --sdk macosx) -o $(EXECUTABLE) \
			-import-objc-header $(EXECUTABLE).swift.h $(EXECUTABLE).swift \
		&& chmod +x $(EXECUTABLE)

clean:
	rm $(EXECUTABLE)

.PHONY: clean
