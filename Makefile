NAME := Caseinator-asm
DNAME := Caseinator-asm-debug

FILES := \
		main.s \
		helpers.s \
		to_lower.s \
		to_upper.s \
		to_snake.s \
		to_camel.s \
		to_pascal.s

SRC_DIR := src
OBJ_DIR := obj
DOBJ_DIR := dobj

SRC := $(addprefix $(SRC_DIR)/, $FILES)
OBJ := $(addprefix $(OBJ_DIR)/, $(FILES:.s=.o))
DOBJ := $(addprefix $(DOBJ_DIR)/, $(FILES:.s=.o))

C_DCYAN := \033[2;34m
C_ORANGE := \033[0;33m
C_RED := \033[0;31m
NC := \033[0m
PREFIX := $(C_ORANGE)<$(NAME)>


all: $(NAME)

dall: $(DNAME)

debug: $(DNAME)

gcc:
	@printf "$(PREFIX) $(NC)CREATING $(NAME)\n"
	@gcc -pie -o $(NAME) $(OBJ) -nostdlib -lc

$(NAME): $(OBJ)
	@printf "$(PREFIX) $(NC)CREATING $(NAME)\n"
	@ld -pie -o $(NAME) $(OBJ) -lc

$(DNAME): $(DOBJ)
	@printf "$(PREFIX) $(NC)CREATING $(DNAME)\n"
	@ld -pie -o $(DNAME) $(DOBJ) -lc

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s $(OBJ_DIR)
	@printf "$(PREFIX) $(C_DCYAN)ASSEMBLING $@$(NC)\n"
	@nasm -f elf64 $< -o $@ -i $(SRC_DIR)

$(DOBJ_DIR)/%.o: $(SRC_DIR)/%.s $(DOBJ_DIR)
	@printf "$(PREFIX) $(C_DCYAN)ASSEMBLING $@$(NC)\n"
	@nasm -f elf64 -g $< -o $@ -i $(SRC_DIR)

$(OBJ_DIR):
	@mkdir $@

$(DOBJ_DIR):
	@mkdir $@


clean:
	@printf "$(PREFIX) $(C_RED)REMOVING OBJECT FILES$(NC)\n"
	@rm -rf $(OBJ_DIR) $(TEST_OBJ) $(DOBJ_DIR) $(TEST_DOBJ)

fclean: clean
	@printf "$(PREFIX) $(C_RED)REMOVING ARCHIVE$(NC)\n"
	@rm -f $(NAME) $(TEST_NAME) $(DNAME) $(TEST_DNAME)

re: fclean all

.PHONY: all test clean fclean re gcc
