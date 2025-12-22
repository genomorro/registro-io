<?php

namespace App;

use Symfony\Component\Console\Messenger\RunCommandMessage;
use Symfony\Component\Scheduler\Attribute\AsSchedule;
use Symfony\Component\Scheduler\Schedule as SymfonySchedule;
use Symfony\Component\Scheduler\ScheduleProviderInterface;
use Symfony\Component\Scheduler\RecurringMessage;
use Symfony\Contracts\Cache\CacheInterface;

#[AsSchedule]
class Schedule implements ScheduleProviderInterface
{
    public function __construct(
        private CacheInterface $cache,
    ) {
    }

    public function getSchedule(): SymfonySchedule
    {
        return (new SymfonySchedule())
            ->stateful($this->cache) // ensure missed tasks are executed
            ->processOnlyLastMissedRun(true) // ensure only last missed task is run

        // add your own tasks here
        // see https://symfony.com/doc/current/scheduler.html#attaching-recurring-messages-to-a-schedule
	    ->add(
		RecurringMessage::every("15 minutes", new RunCommandMessage('app:import-data:hospitalized')),
		RecurringMessage::cron('* */8 * * *', new RunCommandMessage('app:import-data'))
	    )
	    ->add(
		RecurringMessage::cron('0 0 1-7 * 0', new RunCommandMessage('app:compress-image'))
	    )
	;
    }
}
