require 'fiber'

class TaskList
    class Task
        attr_accessor :name
        attr_accessor :process
        attr_accessor :fiber
        def initialize(name, &process)
            @name = name.to_s
            @process = process
            @fiber = Fiber.new(&process)
        end
    end
    private_constant :Task

    def initialize
        @tasks = []
    end

    def push(name)
        p = method(name)
        if(p != nil)
            t = Task.new(name, &p)
            @tasks.push(t)
        end
    end

    def get(i)
        return @tasks[i]
    end

    def run()
        while(true)
            if(@tasks.empty?)
                break;
            else
                @tasks.each{|task| 
                    name = task.name
                    f = task.fiber
                    if f != nil && f.alive?
                        result = f.resume()
                        p name + ' is working at phase ' + result.to_s
                    else 
                        p name + ' is dead'
                        @tasks.delete(task)
                    end
                }
            end
        end
        p 'Eveything was done, task list is empty now'
    end
end

def co_main()
    Fiber.yield 1
    Fiber.yield 2
    Fiber.yield 3
    return 4
end

def co_child()
    Fiber.yield 1
    Fiber.yield 2
    Fiber.yield 3
    Fiber.yield 4
    Fiber.yield 5
    Fiber.yield 6
    Fiber.yield 7
    return 8
end

tasks = TaskList.new()
tasks.push(:co_main)
tasks.push(:co_child)
tasks.run()
