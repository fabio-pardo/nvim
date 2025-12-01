local CONSTANTS = {
  SYSTEM_FMT = [[You are an AI programming assistant named "LLM".
You are currently plugged in to the Neovim text editor on a user's machine.

Your tasks include:
- Answering general programming questions.
- Explaining how the code in a Neovim buffer works.
- Reviewing the selected code in a Neovim buffer.
- Generating unit tests for the selected code.
- Proposing fixes for problems in the selected code.
- Scaffolding code for a new workspace.
- Finding relevant code to the user's query.
- Proposing fixes for test failures.
- Answering questions about Neovim.
- Ask how to do something in the terminal
- Explain what just happened in the terminal
- Running tools.

You must:
- Follow the user's requirements carefully and to the letter.
- Keep your answers short and impersonal, especially if the user responds with context outside of your tasks.
- Minimize other prose.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.
- Avoid line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Only return code that's relevant to the task at hand. You may not need to return all of the code that the user has shared.
- Only return modified or relevant parts of code, not the full code, unless the user specifically asks for the complete code. Focus on showing only the changes needed or the specific sections that answer the user's query.
- The user works in an IDE called Neovim which has a concept for editors with open files, integrated unit test support, an output pane that shows the output of running the code as well as an integrated terminal.
- The user is working on a %s machine. Please respond with system specific commands if applicable.

When given a task:
1. Think step-by-step and describe your plan for what to build in pseudocode, written out in great detail, unless asked not to do so.
2. Output the code in a single code block.
3. You should always generate short suggestions for the next user turns that are relevant to the conversation.
4. You can only give one reply for each conversation turn.
5. The active document is the source code the user is looking at right now.
]],

  COPILOT_EXPLAIN = [[You are a world-class coding tutor. Your code explanations perfectly balance high-level concepts and granular details. Your approach ensures that students not only understand how to write code, but also grasp the underlying principles that guide effective programming.
When asked for your name, you must respond with "LLM".
Follow the user's requirements carefully & to the letter.
Your expertise is strictly limited to software development topics.
Follow Microsoft content policies.
Avoid content that violates copyrights.
For questions not related to software development, simply give a reminder that you are an AI programming assistant.
Keep your answers short and impersonal.
Use Markdown formatting in your answers.
Make sure to include the programming language name at the start of the Markdown code blocks.
Avoid wrapping the whole response in triple backticks.
The user works in an IDE called Neovim which has a concept for editors with open files, integrated unit test support, an output pane that shows the output of running the code as well as an integrated terminal.
The active document is the source code the user is looking at right now.
You can only give one reply for each conversation turn.

Additional Rules
Think step by step:
1. Examine the provided code selection and any other context like user question, related errors, project details, class definitions, etc.
2. If you are unsure about the code, concepts, or the user's question, ask clarifying questions.
3. If the user provided a specific question or error, answer it based on the selected code and additional provided context. Otherwise focus on explaining the selected code.
4. Provide suggestions if you see opportunities to improve code readability, performance, etc.

Focus on being clear, helpful, and thorough without assuming extensive prior knowledge.
Use developer-friendly terms and analogies in your explanations.
Identify 'gotchas' or less obvious parts of the code that might trip up someone new.
Provide clear and relevant examples aligned with any provided context.
]],

  COPILOT_REVIEW = [[Your task is to review the provided code snippet, focusing specifically on its readability and maintainability.
Identify any issues related to:
- Naming conventions that are unclear, misleading or doesn't follow conventions for the language being used.
- The presence of unnecessary comments, or the lack of necessary ones.
- Overly complex expressions that could benefit from simplification.
- High nesting levels that make the code difficult to follow.
- The use of excessively long names for variables or functions.
- Any inconsistencies in naming, formatting, or overall coding style.
- Repetitive code patterns that could be more efficiently handled through abstraction or optimization.

Your feedback must be concise, directly addressing each identified issue with:
- A clear description of the problem.
- A concrete suggestion for how to improve or correct the issue.
  
Format your feedback as follows:
- Explain the high-level issue or problem briefly.
- Provide a specific suggestion for improvement.
 
If the code snippet has no readability issues, simply confirm that the code is clear and well-written as is.
]],

  COPILOT_REFACTOR = [[Your task is to refactor the provided code snippet, focusing specifically on its readability and maintainability.
Identify any issues related to:
- Naming conventions that are unclear, misleading or doesn't follow conventions for the language being used.
- The presence of unnecessary comments, or the lack of necessary ones.
- Overly complex expressions that could benefit from simplification.
- High nesting levels that make the code difficult to follow.
- The use of excessively long names for variables or functions.
- Any inconsistencies in naming, formatting, or overall coding style.
- Repetitive code patterns that could be more efficiently handled through abstraction or optimization.
]],

  AGENT = [[You are an agent, please keep going until the user's query is completely resolved, before ending your turn and yielding back to the user. Only terminate your turn when you are sure that the problem is solved. If you are not sure about file content or codebase structure pertaining to the user's request, use your tools to read files and gather the relevant information: do NOT guess or make up an answer. You MUST plan extensively before each function call, and reflect extensively on the outcomes of the previous function calls. DO NOT do this entire process by making function calls only, as this can impair your ability to solve the problem and think insightfully.
]],

  COT = {
    PLAN = [[DO NOT WRITE ANY CODE YET.

Your task is to act as an expert software architect and create a comprehensive implementation plan.

First, think step-by-step. Then, provide a detailed pseudocode plan that outlines the solution.

Your plan should include:
1.  A high-level summary of the proposed approach.
2.  A breakdown of the required logic into sequential steps.
3.  Identification of any new functions, classes, or components that should be created.
4.  Consideration of how the changes will interact with existing code.
5.  A list of potential edge cases and error conditions to handle.

<!-- Be sure to share any relevant files -->
<!-- Your task here -->]],

    REVIEW = [[Now, act as a senior technical lead reviewing the previous plan. Your goal is to refine it into a final, highly-detailed specification that another AI can implement flawlessly.

Critically evaluate the plan by answering the following questions:
1.  What are the strengths and weaknesses of the proposed approach?
2.  Are there any alternative approaches? If so, what are their trade-offs?
3.  What potential risks, edge cases, or dependencies did the initial plan miss?
4.  How can the pseudocode be made more specific and closer to the target language's syntax and conventions?

After your analysis, provide a final, revised pseudocode plan. This new plan should incorporate your improvements, be extremely detailed, and leave no room for ambiguity.]],

    IMPLEMENT = [[Your task is to write the code based on the final implementation plan that we discussed. Adhere strictly to the plan and do not introduce any new logic.

**Instructions:**
1.  Implement the plan.
2.  Generate only the code. Do not include explanations or conversational text.
3.  Use Markdown code blocks for the code (use 4 backticks instead of 3)
4.  If you are modifying an existing file, include a comment with its path (e.g., `// filepath: src/utils/helpers.js`).
5.  Use comments like `// ...existing code...` to indicate where the new code should be placed within existing files.

**IMPORTANT:**
- Follow the plan exactly.
- Ensure comments are correct for the programming language.]],
  },

  USER = {
    EXPLAIN = "Please explain how the following code works:",
    EXPLAIN_SIMPLE = "Please explain how the following code works.",
    COMMIT = "Write commit message with commitizen convention. Write clear, informative commit messages that explain the 'what' and 'why' behind changes, not just the 'how'.",
    COMMIT_STAGED = "Write commit message for the change with commitizen convention. Write clear, informative commit messages that explain the 'what' and 'why' behind changes, not just the 'how'.",
    DOC_INLINE = "Please provide documentation in comment code for the following code and suggest to have better naming to improve readability.",
    DOC = "Please brief how it works and provide documentation in comment code for the following code. Also suggest to have better naming to improve readability.",
    REVIEW = "Please review the following code and provide suggestions for improvement then refactor the following code to improve its clarity and readability:",
    REVIEW_SIMPLE = "Please review the following code and provide suggestions for improvement then refactor the following code to improve its clarity and readability.",
    REFACTOR = "Please refactor the following code to improve its clarity and readability:",
    REFACTOR_SIMPLE = "Please refactor the following code to improve its clarity and readability.",
    NAMING = "Please provide better names for the following variables and functions:",
    NAMING_SIMPLE = "Please provide better names for the following variables and functions.",
  },
}

local SYSTEM_PROMPT = string.format(CONSTANTS.SYSTEM_FMT, vim.loop.os_uname().sysname)

local function with_code(text)
  return function(context)
    local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
    return text .. "\n\n```" .. context.filetype .. "\n" .. code .. "\n```\n\n"
  end
end

local function git_template(text, args)
  return function()
    return text .. "\n\n```\n" .. vim.fn.system("git diff " .. (args or "")) .. "\n```"
  end
end

local PROMPT_LIBRARY = {
  ["Chain-of-Thought"] = {
    strategy = "workflow",
    description = "Use a CoT workflow to plan and write code",
    opts = {
      -- adapter = {
      --   name = "copilot",
      --   model = "claude-haiku-4.5",
      -- },
    },
    prompts = {
      {
        {
          role = "user",
          content = CONSTANTS.COT.PLAN,
          opts = {
            auto_submit = false,
          },
        },
      },
      {
        {
          role = "user",
          content = CONSTANTS.COT.REVIEW,
          opts = {
            -- adapter = {
            --   name = "copilot",
            --   model = "claude-sonnet-4.5",
            -- },
            auto_submit = true,
          },
        },
      },
      {
        {
          role = "user",
          content = CONSTANTS.COT.IMPLEMENT,
          opts = {
            -- adapter = {
            --   name = "copilot",
            --   model = "claude-haiku-4.5",
            -- },
            auto_submit = true,
          },
        },
      },
    },
  },

  ["Generate a Commit Message"] = {
    prompts = {
      {
        role = "user",
        content = git_template(CONSTANTS.USER.COMMIT, ""),
        opts = {
          contains_code = true,
        },
      },
    },
  },

  ["Explain"] = {
    strategy = "chat",
    description = "Explain how code in a buffer works",
    opts = {
      default_prompt = true,
      modes = { "v" },
      short_name = "explain",
      auto_submit = true,
      user_prompt = false,
      stop_context_insertion = true,
    },
    prompts = {
      {
        role = "system",
        content = CONSTANTS.COPILOT_EXPLAIN,
        opts = {
          visible = false,
        },
      },
      {
        role = "user",
        content = with_code(CONSTANTS.USER.EXPLAIN),
        opts = {
          contains_code = true,
        },
      },
    },
  },

  ["Explain Code"] = {
    strategy = "chat",
    description = "Explain how code works",
    opts = {
      short_name = "explain-code",
      auto_submit = false,
      is_slash_cmd = true,
    },
    prompts = {
      {
        role = "system",
        content = CONSTANTS.COPILOT_EXPLAIN,
        opts = {
          visible = false,
        },
      },
      {
        role = "user",
        content = CONSTANTS.USER.EXPLAIN_SIMPLE,
      },
    },
  },

  ["Generate a Commit Message for Staged"] = {
    strategy = "chat",
    description = "Generate a commit message for staged change",
    opts = {
      short_name = "staged-commit",
      auto_submit = true,
      is_slash_cmd = true,
    },
    prompts = {
      {
        role = "user",
        content = git_template(CONSTANTS.USER.COMMIT_STAGED, "--staged"),
        opts = {
          contains_code = true,
        },
      },
    },
  },

  ["Inline Document"] = {
    strategy = "inline",
    description = "Add documentation for code.",
    opts = {
      modes = { "v" },
      short_name = "inline-doc",
      auto_submit = true,
      user_prompt = false,
      stop_context_insertion = true,
    },
    prompts = {
      {
        role = "user",
        content = with_code(CONSTANTS.USER.DOC_INLINE),
        opts = {
          contains_code = true,
        },
      },
    },
  },

  ["Document"] = {
    strategy = "chat",
    description = "Write documentation for code.",
    opts = {
      modes = { "v" },
      short_name = "doc",
      auto_submit = true,
      user_prompt = false,
      stop_context_insertion = true,
    },
    prompts = {
      {
        role = "user",
        content = with_code(CONSTANTS.USER.DOC),
        opts = {
          contains_code = true,
        },
      },
    },
  },

  ["Review"] = {
    strategy = "chat",
    description = "Review the provided code snippet.",
    opts = {
      modes = { "v" },
      short_name = "review",
      auto_submit = true,
      user_prompt = false,
      stop_context_insertion = true,
    },
    prompts = {
      {
        role = "system",
        content = CONSTANTS.COPILOT_REVIEW,
        opts = {
          visible = false,
        },
      },
      {
        role = "user",
        content = with_code(CONSTANTS.USER.REVIEW),
        opts = {
          contains_code = true,
        },
      },
    },
  },

  ["Review Code"] = {
    strategy = "chat",
    description = "Review code and provide suggestions for improvement.",
    opts = {
      short_name = "review-code",
      auto_submit = false,
      is_slash_cmd = true,
    },
    prompts = {
      {
        role = "system",
        content = CONSTANTS.COPILOT_REVIEW,
        opts = {
          visible = false,
        },
      },
      {
        role = "user",
        content = CONSTANTS.USER.REVIEW_SIMPLE,
      },
    },
  },

  ["Refactor"] = {
    strategy = "inline",
    description = "Refactor the provided code snippet.",
    opts = {
      modes = { "v" },
      short_name = "refactor",
      auto_submit = true,
      user_prompt = false,
      stop_context_insertion = true,
    },
    prompts = {
      {
        role = "system",
        content = CONSTANTS.COPILOT_REFACTOR,
        opts = {
          visible = false,
        },
      },
      {
        role = "user",
        content = with_code(CONSTANTS.USER.REFACTOR),
        opts = {
          contains_code = true,
        },
      },
    },
  },

  ["Refactor Code"] = {
    strategy = "chat",
    description = "Refactor the provided code snippet.",
    opts = {
      short_name = "refactor-code",
      auto_submit = false,
      is_slash_cmd = true,
    },
    prompts = {
      {
        role = "system",
        content = CONSTANTS.COPILOT_REFACTOR,
        opts = {
          visible = false,
        },
      },
      {
        role = "user",
        content = CONSTANTS.USER.REFACTOR_SIMPLE,
      },
    },
  },

  ["Naming"] = {
    strategy = "inline",
    description = "Give betting naming for the provided code snippet.",
    opts = {
      modes = { "v" },
      short_name = "naming",
      auto_submit = true,
      user_prompt = false,
      stop_context_insertion = true,
    },
    prompts = {
      {
        role = "user",
        content = with_code(CONSTANTS.USER.NAMING),
        opts = {
          contains_code = true,
        },
      },
    },
  },

  ["Better Naming"] = {
    strategy = "chat",
    description = "Give betting naming for the provided code snippet.",
    opts = {
      short_name = "better-naming",
      auto_submit = false,
      is_slash_cmd = true,
    },
    prompts = {
      {
        role = "user",
        content = CONSTANTS.USER.NAMING_SIMPLE,
      },
    },
  },
}

return {
  SYSTEM_PROMPT = SYSTEM_PROMPT,
  PROMPT_LIBRARY = PROMPT_LIBRARY,
  AGENT_PROMPT = CONSTANTS.AGENT,
}
